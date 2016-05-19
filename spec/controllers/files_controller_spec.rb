require 'rails_helper'

RSpec.describe FilesController, :type => :controller do
  before do
    @attachment1 = {file_name: 'something1', doc: 'something1', public: true}
    @attachment2 = {file_name: 'something2', doc: 'something2', public: false}
    @attachment3 = {file_name: 'something3', doc: 'something3', public: true}
  end

  describe 'GET #public_files' do
    before do
      get :public_files
    end

    it 'responds successfully with an HTTP 200 status code' do
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      expect(response).to render_template('public_files')
    end

    it 'can show list of public files only' do
      Attachment.create(**@attachment1)
      Attachment.create(**@attachment2)
      Attachment.create(**@attachment3)
      attachments = assigns(:attachments)
      attachments.each do |attachment|
        expect(attachment.public).to eq(true)
      end
    end

    it 'can show empty list if there are no publicly shared' do
      expect(assigns(:attachments)).to eq([])
    end
  end
end
