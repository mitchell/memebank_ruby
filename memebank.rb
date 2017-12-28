require 'rest_client'
require 'sinatra/base'
require 'json'

# Memebank application class
class Memebank < Sinatra::Application
  enable :sessions

  not_found do
    slim :not_found, layout: :application
  end

  private

  @@api_url = 'https://api.memebank.life' # rubocop:disable Style/ClassVars

  def retrieve_cards
    @cards = RestClient.get "#{@@api_url}/banks/#{@bank_id}/cards"
    @cards = JSON.parse @cards, symbolize_names: true
  end

  def check_session_retrieve_banks
    @banks = RestClient.get "#{@@api_url}/banks",
                            authorization: 'Authorization: Bearer ' \
                            "#{session[:user_token]}"
    @banks = JSON.parse @banks, symbolize_names: true
  rescue RestClient::BadGateway
    redirect to('/')
  end
end

require_relative 'routes/login_register'
require_relative 'routes/banks'
require_relative 'routes/cards'
