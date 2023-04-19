class ShoppinglistController < ApplicationController
  before_action :find_user

  def index
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
end
