class RecipeFoodsController < ApplicationController
  load_and_authorize_resource

  before_action :find_recipe
  before_action :find_user
  before_action :find_food

  def index
    if can? :manage, @recipe
      @foods = @user.foods.all
      @recipe_foods = RecipeFood.all
      puts 'Can MAnage'
    else
      puts 'Can Not Manage'
      @recipe_foods = []
      @foods = []
      flash[:alert] = 'Un Authorized'
      redirect_to recipe_path(id: @recipe.id)
    end
  end

  def show
    @recipe_food = @recipe.recipe_foods
  end

  def new
    @foods = @user.foods.all
    @recipe_food = RecipeFood.new
  end

  def edit
    return if can? :edit, @recipe

    flash[:alert] = 'Un Authorized'
    redirect_to recipe_path(id: @recipe.id)
  end

  def update
    @recipe_food = RecipeFood.find_by_id(params[:id])
    @recipe_food.quantity = params[:quantity]
    if @recipe_food.save
      redirect_to recipe_path(@recipe), notice: 'Recipe Food was updated successfully'
    else
      flash.now[:alert] = @recipe_food.errors.full_messages.first if @recipe_food.errors.any?
      render :edit, status: 400
    end
  end

  def create
    @recipe_food = RecipeFood.new(recipe_food_params)
    @recipe_food.recipe = @recipe
    if @recipe_food.save
      redirect_to recipe_path(@recipe), notice: 'Recipe Food created successfully'
    else
      flash.now[:alert] = @recipe_food.errors.full_messages.first if @recipe_food.errors.any?
      render :new, status: 400
    end
  end

  def destroy
    if can? :edit, @recipe
      @recipe_food = RecipeFood.find(params[:id])
      if @recipe_food.destroy
        redirect_to recipe_path(@recipe), notice: 'Recipe Food was deleted successfully'
      else
        flash.now[:alert] = @recipe_food.errors.full_messages.first if @recipe_food.errors.any?
        render :new, status: 400
      end
    else
      flash[:alert] = 'Un Authorized'
      redirect_to recipe_path(id: @recipe.id)
    end
  end

  private

  def find_user
    @user = current_user
  end

  def find_recipe
    @recipe = Recipe.find_by_id(params[:recipe_id])
  end

  def find_food
    @food = Food.find_by_id(params[:food_id])
  end

  def recipe_food_params
    params.require(:recipe_food).permit(:quantity, :recipe_id, :food_id)
  end
end
