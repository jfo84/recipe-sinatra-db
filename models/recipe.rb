require 'pry'

require_relative '../sql_query'
require_relative 'ingredient'

class Recipe

  attr_accessor :id, :name, :instructions, :description

  def initialize(id, name, instructions, description)
    @id = id
    @name = name
    @instructions = instructions
    @description = description
  end

  def ingredients
    id = [@id.to_i]
    ingredient_query = db_connection {|conn| conn.exec_params("SELECT ingredients.name
                                                        FROM ingredients
                                                        JOIN recipes ON ingredients.recipe_id = recipes.id
                                                        WHERE recipes.id = $1", id) }
    ingred_array = []
    ingredient_query.values.each do |ingredient|
      ingred_array << Ingredient.new(ingredient)
    end
    return ingred_array
  end

  def self.all
    @recipe_query = db_connection { |conn| conn.exec("SELECT * FROM recipes") }
    @recipe_query = @recipe_query.to_a
    @recipe_query.map! do |recipe|
      Recipe.new(recipe["id"], recipe["name"], recipe["instructions"], recipe["description"])
    end
  end

  def self.find(id)
    find = @recipe_query.select {|recipe| recipe.id == id}
    return find[0]
  end

end
