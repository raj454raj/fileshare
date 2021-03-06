class FilesController < ApplicationController
  include AbstractController::Callbacks
  before_filter :require_user, except: [:public_files, :download_file, :show]

  def index
    @attachments = Attachment.all
  end

  def new
  end

  def public_files
    @attachments = Attachment.where(public: true)
  end

  def download_file
    @attachment = Attachment.find(params[:id])
    extension = get_extension(@attachment.location)
    new_filename = @attachment.file_name
    new_filename += '.' + extension if extension.nil? == false
    send_file(@attachment.location,
              filename: new_filename)
  end

  def show
    @user = User.find(params[:user_id])
    @attachment = Attachment.find(params[:id])
  end

  def edit
    @user = User.find(session[:user_id])
    redirect_to user_path(@user) if session[:user_id] != params[:user_id].to_i
    @attachment = @user.attachments.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @attachment = @user.attachments.find(params[:id])
    @attachment.update_attributes(params[:attachment])
    redirect_to user_file_path(@user, @attachment)
  end

  def create
    @user = User.find(params[:user_id])
    attachment = params[:attachment]
    file_name = attachment[:file_name]
    file_path = get_file_path(file_name)
    attachment[:location] = file_path
    _, file_path = write_to_file(attachment, file_name, file_path)
    attachment[:location] = file_path
    attachment.delete(:file_upload)
    @attachment = @user.attachments.new(attachment)
    if @attachment.save
      redirect_to user_path(@user)
    else
      redirect_to action: 'new'
    end
  end

  def destroy
    user = User.find(params[:user_id])
    redirect_to user_path(user) if session[:user_id] != params[:user_id].to_i
    attachment = user.attachments.find(params[:id])
    File.delete(attachment.location)
    attachment.destroy
    redirect_to user_path(user)
  end

  private

  def write_to_file(attachment, file_name, file_path)
    uploaded_io = attachment[:file_upload]
    file_name = uploaded_io.original_filename
    file_path = get_file_path(file_name)
    file_name, file_path = get_new_file_name(file_name, file_path)

    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    [file_name, file_path]
  end

  def get_extension(file_location)
    filename = file_location.split('/')[-1]
    parts = filename.split('.')
    parts.length == 1 ? nil : parts[-1]
  end

  def get_file_path(file_name)
    Rails.root.join('public', 'uploads', file_name).to_s
  end

  def is_i?(str)
    true if Integer(str) rescue false
  end

  # Checks if a file exists and if exists then enumerates
  # the new files with same name and adds _<next_number>
  # Worst code I have ever written
  def get_new_file_name(file_name, file_path)
    extension = get_extension(file_name)
    parts = file_name.split('.')
    file_name = parts[0, parts.length - 1].join('.')
    while File.exist?(file_path)
      parts = file_name.split('_')
      if is_i?(parts[-1])
        n = parts[-1].to_i + 1
        file_name = parts[0, parts.length - 1].join('_') + "_#{n}"
      else
        file_name += '_1'
      end
      file_path = get_file_path(file_name)
      file_path += '.' + extension unless extension.nil?
    end
    file_name += '.' + extension unless extension.nil?
    [file_name, file_path]
  end
end
