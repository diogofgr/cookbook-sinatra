
def get_search_page(search_term)
  base_url = "http://www.letscookfrench.com"
  search_term = search_term.nil? ? "" : search_term

  search_url = base_url + "/recipes/find-recipe.aspx?aqt=" + search_term

  doc = Nokogiri::HTML(open(search_url), nil, 'utf-8')

  recipe_nodes = doc.css("div.m_contenu_resultat")
  recipes = []

  recipe_nodes.each do |recipe_node|
    name = recipe_node.css('div.m_titre_resultat').text
    description = recipe_node.css('div.m_texte_resultat').text
    recipe_url = base_url + recipe_node.css('div.m_titre_resultat > a').attribute('href').text

    recipe = [name, description, recipe_url]
    recipe = recipe.map do |property|
      property.delete("\r").delete("\n").strip.gsub(/\s+/, ' ')
    end
    recipe_object = Recipe.new(recipe[0], recipe[1], recipe[2])
    recipes << recipe_object
  end

  recipes
end

def get_more_info(recipe_page_url)
  doc = Nokogiri::HTML(open(recipe_page_url), nil, 'utf-8')

  recipe_name = doc.css("h1").text
  preparation_time = doc.css("span.preptime").text
  cooking_time = doc.css("span.cooktime").text
  ingredients = doc.css("div.m_content_recette_ingredients").text
  instructions = doc.css("div.m_content_recette_todo").text

  recipe_details = [recipe_name, preparation_time, cooking_time, ingredients, instructions]
  recipe_details = recipe_details.map do |detail|
    detail.delete("\r").delete("\n").strip.gsub(/\s+/, ' ')
  end
  recipe_details
end
