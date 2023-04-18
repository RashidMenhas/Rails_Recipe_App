class ShoppinglistController < ApplicationController
  before_action :find_user
  # before_action :find_recipe

  def index
    # @total_price = @recipe_foods.sum { |recipe_food| recipe_food.food.price * recipe_food.quantity }
    @total_foods = 0
    @total_price = 0
    @recipe_foods = []
    @user.recipes.each do |recipe|
      recipe.recipe_foods.each do |recipe_food|
        @total_foods += 1
        @total_price += recipe_food.food.price * recipe_food.quantity
        @recipe_foods << recipe_food
      end
    end
  end

  private

  def find_user
    @user = current_user
  end
  # def find_recipe
  #   @recipe = Recipe.find(params[:recipe_id])
  # end

  def show
    # @recipe = @user.recipes.find(params[:id])
    @recipe = Recipe.includes(:recipe_foods).find(params[:id])
    @recipe_foods = @recipe.recipe_foods
  end
end
