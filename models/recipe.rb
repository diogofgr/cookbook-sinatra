class Recipe
  attr_reader :name, :description, :url, :prep_time, :cook_time, :ingredients, :instructions, :done
  attr_writer :prep_time, :cook_time, :ingredients, :instructions, :done

  def initialize(name, description, url = "--", prep_time = "--", cook_time = "--", ingredients = "--", instructions = "--", done = false)
    @name = name
    @description = description
    @url = url
    @prep_time = prep_time
    @cook_time = cook_time
    @ingredients = ingredients
    @instructions = instructions
    @done = done
  end

  def is_done?
    # remember @done is stored in the CSV as a string, not a boolean:
    return true if @done == "true"
  end

  def has_all_details?
    details = [@name, @description, @url, @prep, @cook, @ingredients, @instructions]
    details.each do |detail|
      return false if detail == "--"
    end
  end

  def from_the_web?
    @url != "--"
  end

  def update_details(details_array)
    @prep_time = details_array[1]
    @cook_time = details_array[2]
    @ingredients = details_array[3]
    @instructions = details_array[4]
  end

end
