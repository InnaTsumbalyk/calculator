Rails.application.routes.draw do

  root 'pages#credit_calculator'

  get 'calculate_credit', to: 'pages#calculate_credit', as: :calculate_credit
  get 'download_calc_result', to: 'pages#download_calc_result', as: :download_calc_result

end
