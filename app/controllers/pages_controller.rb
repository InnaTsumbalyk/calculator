class PagesController < ApplicationController
  require 'credit_calculator'

  def calculate_credit
    calculator = CreditCalculator.new(params[:credit_period], params[:credit_sum], params[:percent_rate], params[:scheme])
    @calc = calculator.calculate
  end

end
