class RecipesController < ApplicationController
  load_and_authorize_resource

  before_action :find_user

  def index
    @recipes = @user.recipes.all
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_foods = @recipe.recipe_foods.includes(:food)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = @user
    if @recipe.save
      redirect_to recipe_path(id: @recipe.id), notice: 'Recipe created successfully'
    else
      flash.now[:alert] = @recipe.errors.full_messages.first if @recipe.errors.any?
      render :new, status: 400
    end
  end

  def edit
    @food = Food.find_by_id(params[:id])
    @recipe = Recipe.find(params[:id])
  end

  def update
    @food = Food.find_by_id(params[:id])
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      redirect_to recipe_path(id: @recipe.id), notice: 'Recipe updated successfully'
    else
      flash.now[:alert] = @recipe.errors.full_messages.first if @recipe.errors.any?
      render :edit, status: 400
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe_foods = RecipeFood.where(recipe_id: @recipe.id)
    @recipe_foods.each(&:destroy)
    if @recipe.destroy
      redirect_to recipes_path, notice: 'Recipe was deleted successfully'
    else
      flash.now[:alert] = @recipe.errors.full_messages.first if @recipe.errors.any?
      render :index, status: 400
    end
  end

  def toggle
    @recipe = Recipe.find(params[:id])
    @recipe.public = !@recipe.public
    text = @recipe.public? ? 'public' : 'private'

    if @recipe.save
      flash[:notice] = "#{@recipe.name} is now #{text}!"
    elsif @recipe.errors.any?
      flash[:alert] = @recipe.errors.full_messages.first
    end
    redirect_to recipe_path(id: @recipe.id)
  end

  private

  def find_user
    @user = current_user
  end

  def recipe_params
    params.require(:recipe).permit(:name, :description, :preparation_time, :cooking_time, :public)
  end
end
