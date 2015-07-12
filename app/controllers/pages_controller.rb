# coding: utf-8
class PagesController < ApplicationController

  def calculate_credit
    calculator = CreditCalculator.new(params[:credit_period], params[:credit_sum], params[:percent_rate], params[:scheme])
    if calculator.valid?
      @calc = calculator.calculate
    else
      @error_messages = calculator.errors
    end
  end

end
