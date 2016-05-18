class SessionsController < ApplicationController
  def new
  end

  def create
    p params
    user = User.authenticate(params[:session][:username],
                             params[:session][:password])
    if user
      session[:user_id] = user.id
      redirect_to '/files/'
    else
      flash.now.alert = 'Invalid username or password'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/files/'
  end
end
