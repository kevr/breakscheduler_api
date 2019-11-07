require 'rails_helper'

RSpec.describe MiscController, type: :controller do

  context 'misc routes' do

    it 'json not_found action' do
      headers = {
        "Accept" => "application/json"
      }
      request.headers.merge! headers

      get :not_found
      expect(response.code).to eq '404'

      data = ActiveSupport::JSON.decode(response.body)
      expect(data['error']).to eq "Endpoint not found"
    end

    it 'html not_found action' do
      headers = {
        "Accept" => "text/html"
      }
      request.headers.merge! headers

      get :not_found
      expect(response.code).to eq '404'
    end

  end

end
