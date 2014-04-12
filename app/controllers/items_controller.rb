class ItemsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      flash[:success] = "Item created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def item_params
      params.require(:item).permit(:avatar, :description, :title) #strong parameters
    end

end