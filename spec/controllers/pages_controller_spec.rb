require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #credit_calculator" do
    it "returns http success" do
      get :credit_calculator
      expect(response).to have_http_status(:success)
    end
  end

  describe "calculate_credit validations returns error if " do
    it "credit_period blank" do
      xhr :get, :calculate_credit, credit_period: '', credit_sum: 5000, percent_rate: 12, scheme: 'annuity', format: 'js'
      expect(assigns(:error_messages)).not_to be_nil
    end
    it "credit_sum = 0" do
      xhr :get, :calculate_credit, credit_period: 10, credit_sum: 0, percent_rate: 12, scheme: 'annuity', format: 'js'
      expect(assigns(:error_messages)).not_to be_nil
    end
    it "percent_rate > 100" do
      xhr :get, :calculate_credit, credit_period: 10, credit_sum: 5000, percent_rate: 120, scheme: 'annuity', format: 'js'
      expect(assigns(:error_messages)).not_to be_nil
    end
    it "percent_rate blank" do
      xhr :get, :calculate_credit, credit_period: 10, credit_sum: 5000, percent_rate: '', scheme: 'annuity', format: 'js'
      expect(assigns(:error_messages)).not_to be_nil
    end
    it "scheme not equal annuity or standard" do
      xhr :get, :calculate_credit, credit_period: 10, credit_sum: 5000, percent_rate: 12, scheme: 'scheme', format: 'js'
      expect(assigns(:error_messages)).not_to be_nil
    end
  end

  describe "calculate_credit should returns " do
    it 'calculation result' do
      xhr :get, :calculate_credit, credit_period: 10, credit_sum: 5000, percent_rate: 12, scheme: 'annuity', format: 'js'
      expect(assigns(:calc)).not_to be_nil
    end
    it 'annuity scheme result' do
      xhr :get, :calculate_credit, credit_period: 10, credit_sum: 5000, percent_rate: 12, scheme: 'annuity', format: 'js'
      expect(assigns(:calc).payment).to eq(527.91)
    end
    it 'standard scheme result' do
      xhr :get, :calculate_credit, credit_period: 10, credit_sum: 5000, percent_rate: 12, scheme: 'standard', format: 'js'
      expect(assigns(:calc).total_sum).to eq(5275.00)
    end
    it 'payment_months array' do
      xhr :get, :calculate_credit, credit_period: 10, credit_sum: 5000, percent_rate: 12, scheme: 'standard', format: 'js'
      expect(assigns(:calc).payment_months.length).not_to eq(0)
    end
  end

end
