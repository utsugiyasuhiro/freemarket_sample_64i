class GoodsController < ApplicationController
  before_action :move_to_sign_up, except: :show
  def show
    @good = Good.find(params[:id])
  end
  
  def new
    @good = Good.new
    @good.images.build
    @good.category_goods.build
  end

  def create
    @good = Good.new(good_params)
    if @good.save
      params[:images][:image].each do |image|
        Image.create(image: image, good_id: @good.id )
      end
      params[:category_ids][:category_id].each do |category_id|
        CategoryGood.create(category_id: category_id, good_id: @good.id)
      end
      redirect_to root_path
    end

  end

  def edit
    @good = Good.find(params[:id])
  end

  def selledit
    @good = Good.find(params[:id])
  end

  def update
    good = Good.find(params[:id])
    good.update(good_params)
    if good.update(good_params)
      images = Image.where( good_id: good.id)
      images.each do |image|
        image.destroy
      end
      params[:images][:image].each do |image|
        Image.create(image: image, good_id: good.id )
      end
      categories = CategoryGood.where( good_id: good.id)
      categories.each do |category|
        category.destroy
      end
      params[:category_ids][:category_id].each do |category_id|
        CategoryGood.create(category_id: category_id, good_id: good.id)
      end

      redirect_to root_path
    end
  end



  private
  def good_params
    params.require(:good).permit(:name, :explain, :size, :price, :method, :ship, :burden, 
      :status, :brand_id, :area_id, :user_id, images_attribute: [:image], category_ids: [])
  end

  def move_to_sign_up
    redirect_to new_user_session_path unless user_signed_in?
  end
end


