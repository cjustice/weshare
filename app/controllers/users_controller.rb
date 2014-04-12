class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
    @usersall = User.find(:all)
    @usersloc = []
    @usersall.each_index do |i|
      if !(@usersall[i][:address].nil?)
        @usersloc.push @usersall[i]
      end
    end
    @hash2 = Gmaps4rails.build_markers(@usersloc) do |user, marker|
      if !(user.latitude.nil?)
        marker.lat user.latitude
        marker.lng user.longitude
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @items = @user.items.paginate(page: params[:page])
    @hash = Gmaps4rails.build_markers(@user) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
    end
  end

  def new
  	@user = User.new
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to WeShare!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :address)
    end

    #before filters
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url
        flash[:danger] = "Please sign in"
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
