class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user
    else
      flash.now.alert = 'Form has errors'
      redirect_to '/signup'
    end
  end

  def show
    redirect_to '/login' if session[:user_id].nil?
    @user = User.find(params[:id])
  end
end
