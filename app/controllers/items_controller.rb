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
    @item = Item.find(params[:id])
    @user = @item.user
    @hash = Gmaps4rails.build_markers(@user) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
    end
  end

  def destroy
    @item.destroy
    redirect_to root_url
  end

  def index
    @search = params[:search].capitalize
    if params[:search]
      @items = Item.search(params[:search]).order("created_at DESC").paginate(page: params[:page])
    else
      @items = Item.all.order('created_at DESC')
    end
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