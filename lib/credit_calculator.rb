# coding: utf-8
class CreditCalculator
  require 'csv'

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
      self
    end
  end

  def valid?
    validate
    @errors.count == 0
  end

  def to_csv(options = {})
    calculate
    columns = ['Месяц', 'Задолженность по кредиту', 'Погашение кредита', 'Проценты по кредиту', 'Выплаты в месяц']
    CSV.generate(options) do |csv|
      csv << ['Cхема начисления процентов:', I18n.t(@scheme.to_sym)]
      csv << ['Срок кредитования:', "#{@credit_period} месяцев"]
      csv << ['Сумма кредита:', @credit_sum]
      csv << ['Сумма выплат:', @total_sum.round(2)]
      csv << ['Переплата по кредиту:', (@total_sum - @credit_sum).round(2)]
      csv << ['']
      csv << columns
      @payment_months.each { |m| csv << m.values }
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

  def validate
    @errors << 'Неверная схема начисления процентов' unless ['annuity', 'standard'].include?(@scheme)
    @errors << 'Срок кредитования не может быть менше 1 месяца' if @credit_period < 1
    @errors << 'Введите сумму кредита' if @credit_sum < 1
    @errors << 'Процентная ставка должна быть в диапазоне 1..100' if @percent_rate < 1 || @percent_rate > 100
  end


end