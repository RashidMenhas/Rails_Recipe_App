class FoodsController < ApplicationController
  load_and_authorize_resource

  before_action :set_food, only: %i[show edit update destroy]
  before_action :find_user

  def index
    @foods = @user.foods.all
  end

  def show; end

  def new
    @food = Food.new
    puts "Recipe #{params[:recipe_id]}"
  end

  def edit; end

  def create
    @food = Food.new(food_params)
    @food.user = @user

    respond_to do |format|
      if @food.save
        if params[:recipe_id].nil?
          format.html { redirect_to food_url(@food), notice: 'Food was successfully created.' }
        else
          format.html do
            redirect_to recipe_foods_path(params[:recipe_id]), notice: 'Food for recipe added successfully.'
          end
        end
        format.json { render :show, status: :created, location: @food }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @food.update(food_params)
        format.html { redirect_to food_url(@food), notice: 'Food was successfully updated.' }
        format.json { render :show, status: :ok, location: @food }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    food_recipes_count = RecipeFood.where(food_id: @food.id).count

    respond_to do |format|
      if food_recipes_count.positive?
        format.html do
          redirect_to foods_url, notice: "You cannot remove this food. #{food_recipes_count} recipies have it."
        end
      else
        @food.destroy
        format.html { redirect_to foods_url, notice: 'Food was successfully destroyed.' }
      end
      format.json { head :no_content }
    end
  end

  private

  def find_user
    @user = current_user
  end

  def set_food
    @food = Food.find(params[:id])
  end

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :price, :quantity, :user_id)
  end
end
