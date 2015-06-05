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
    ingredient_query = db_connection {|conn| conn.exec("SELECT ingredients.name
                                                        FROM ingredients
                                                        JOIN recipes ON recipes.id = ingredients.recipe_id
                                                        WHERE recipes.id == #{params[:id]}")}
    return ingredient_query
  end

  def self.all
    @recipe_query = db_connection { |conn| conn.exec("SELECT * FROM recipes") }
    @recipe_query = @recipe_query.to_a
    @recipe_query.map! do |recipe|
      Recipe.new(recipe["id"], recipe["name"], recipe["instructions"], recipe["description"])
    end
  end

  def self.find(id)
    @recipe_query.select {|recipe| recipe.id == id}.first
  end

end
