class SessionsController < ApplicationController
  def new
  end

  def create
    p params
    user = User.authenticate(params[:session][:username],
                             params[:session][:password])
    if user
      session[:user_id] = user.id
      redirect_to user
    else
      flash.now.alert = 'Invalid username or password'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    render 'new'
  end
end
