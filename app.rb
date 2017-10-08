require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require 'open-uri'
require 'nokogiri'
require 'csv'

require_relative "models/parser.rb"
require_relative "models/recipe.rb"
require_relative "models/cookbook.rb"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)
web_recipes = []
saved_recipes = []

get '/' do
  erb :index
end

get '/cookbook' do
  saved_recipes = cookbook.all
  @recipes = saved_recipes
  erb :cookbook
end

get '/new' do
  if params[:text] != "" # if it comes from a web search:
    recipe_index = params[:text].to_i-1
    recipe = cookbook.add_recipe(web_recipes[recipe_index])
    redirect '/cookbook'
  else
    erb :new
  end
end

get '/confirm/:index' do
  @recipe_index = params[:index].to_i
  @recipe = saved_recipes[@recipe_index]
  erb :confirm
end

get '/delete/:index' do
  recipe_index = params[:index].to_i
  cookbook.remove_recipe(recipe_index)

  redirect '/cookbook'
end

get '/search' do
  if params[:text] != ""
    search_ingredient = params[:text]
    web_recipes = get_search_page(search_ingredient)
    @recipes = web_recipes
  end
  erb :search
end

get '/show/:index' do
  @recipe_index = params[:index].to_i-1
  @recipe = saved_recipes[@recipe_index]
  if @recipe.from_the_web? && !@recipe.has_all_details?
    # get details on the website
    details = get_more_info(@recipe.url)
    cookbook.update_recipe(@recipe_index, details)
  end
  erb :show
end

get '/markdone/:index' do
  recipe_index = params[:index].to_i
  cookbook.recipe_done!(recipe_index)
  redirect "/show/#{recipe_index + 1}"
end
