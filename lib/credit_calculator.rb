class CreditCalculator
  attr_reader :credit_period, :credit_sum, :percent_rate, :payment, :payment_months, :total_sum, :scheme, :errors

  def initialize(credit_period, credit_sum, percent_rate, scheme)
    @credit_period = credit_period.to_i
    @credit_sum = credit_sum.to_i
    @percent_rate = percent_rate.to_f
    @payment = 0
    @total_sum = 0
    @payment_months = []
    @errors = []
    @scheme = scheme
  end

  def calculate
    if @scheme == 'annuity'
      annuity_calc
    elsif @scheme == 'standard'
      standard_calc
    else
      @errors << 'Scheme type error'
    end
  end

  private

  def annuity_calc
    p = (@percent_rate/100)/12
    @payment = (@credit_sum*(p+p/(((1+p)**@credit_period)-1))).round(2)
    current_sum = @credit_sum
    @payment_months = (1..@credit_period).map do |m|
      credit_payment = (current_sum*(@percent_rate/100)/12).round(2)
      main_payment = (@payment - credit_payment).round(2)
      month_hash = {number: m, sum: current_sum, main_payment: main_payment, credit_payment: credit_payment, payment: @payment}
      current_sum = (current_sum - main_payment).round(2)
      @total_sum = @total_sum + @payment
      month_hash
    end
    self
  end

  def standard_calc
    current_sum = @credit_sum
    main_payment = @credit_sum/@credit_period
    @payment_months = (1..@credit_period).map do |m|
      credit_payment = (current_sum*(@percent_rate/100)/12).round(2)
      month_hash = {number: m, sum: current_sum, main_payment: main_payment, credit_payment: credit_payment, payment: main_payment + credit_payment}
      current_sum = (@credit_sum - main_payment*m).round(2)
      @total_sum = @total_sum + month_hash[:payment]
      month_hash
    end
    self
  end


end