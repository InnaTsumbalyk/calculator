Rails.application.routes.draw do

  root 'pages#credit_calculator'

  get 'calculate_credit', to: 'pages#calculate_credit', as: :calculate_credit

end
