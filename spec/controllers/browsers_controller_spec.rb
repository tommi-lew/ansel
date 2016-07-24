require 'rails_helper'

describe BrowsersController do
  describe 'GET index' do
    it 'assigns instance variable' do
      browsers = create_list(:browser, 2)
      get :index
      expect(assigns(:browsers)).to eq(browsers)
    end
  end
end
