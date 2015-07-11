require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #credit_calculator" do
    it "returns http success" do
      get :credit_calculator
      expect(response).to have_http_status(:success)
    end
  end

end
