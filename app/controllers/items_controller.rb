class ItemsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      flash[:success] = "Item created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def show
    @item = current_user.items.find(params[:id])
  end

  def destroy
    @item.destroy
    redirect_to root_url
  end

  private

    def item_params
      params.require(:item).permit(:avatar, :description, :title) #strong parameters
    end

    def correct_user
      @item = current_user.items.find_by(id: params[:id])
      redirect_to root_url if @item.nil?
    end

end