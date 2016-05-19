class FilesController < ApplicationController
  include AbstractController::Callbacks
  before_filter :authenticate_user!, except: [:public_files, :download_file, :show]

  def index
    @attachments = Attachment.all
  end

  def new
    @attachment = Attachment.new
  end

  def public_files
    @attachments = Attachment.where(public: true)
  end

  def show
    @user = User.find(params[:user_id])
    @attachment = Attachment.find(params[:id])
    redirect_to public_files_path if (!@attachment.public) && \
                                     ((user_signed_in? &&
                                       current_user.id != @user.id) || \
                                      !user_signed_in?)
  end

  def edit
    redirect_to user_path(current_user) if current_user.id != params[:user_id].to_i
    @attachment = current_user.attachments.find(params[:id])
  end

  def update
    @attachment = current_user.attachments.find(params[:id])
    @attachment.update_attributes(params[:attachment])
    redirect_to user_file_path(current_user, @attachment)
  end

  def create
    @attachment = current_user.attachments.new(params[:attachment])
    if @attachment.save
      redirect_to user_path(current_user)
    else
      redirect_to action: 'new'
    end
  end

  def destroy
    redirect_to user_path(current_user) if current_user.id != params[:user_id].to_i
    attachment = current_user.attachments.find(params[:id])
    attachment.destroy
    redirect_to user_path(current_user)
  end
end
