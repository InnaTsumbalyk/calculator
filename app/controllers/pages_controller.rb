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

  def download_calc_result
    calculator = CreditCalculator.new(params[:credit_period], params[:credit_sum], params[:percent_rate], params[:scheme])
    if calculator.valid?
      respond_to do |format|
        format.csv { send_data(calculator.to_csv) }
        format.xls { send_data(calculator.to_csv(col_sep: "\t")) }
      end
    else
      redirect_to root_path
    end
  end

end
