class Cookbook
  def initialize(csv_file)
    @csv_file = csv_file
    @recipes = []
    load_from_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes.push(recipe)
    store_in_csv
  end

  def update_recipe(recipe_index, details_array)
    re = @recipes[recipe_index]
    re.prep_time = details_array[1]
    re.cook_time = details_array[2]
    re.ingredients = details_array[3]
    re.instructions = details_array[4]
    store_in_csv
  end

  def recipe_done!(recipe_index)
    re = @recipes[recipe_index]
    re.done = re.is_done? ? "false" : "true"
    store_in_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    store_in_csv
  end

  private

  def store_in_csv
    CSV.open(@csv_file, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.url, recipe.prep_time, recipe.cook_time, recipe.ingredients, recipe.instructions, recipe.done]
      end
    end
  end

  def load_from_csv
    CSV.foreach(@csv_file) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7])
    end
    @recipes
  end
end
