class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_username(params[:session][:username])
#    if @user && @user.authenticate(params[:session][:password_digest])

    if @user
      session[:user_id] = @user.id
      redirect_to '/files/'
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/files/'
  end
end
