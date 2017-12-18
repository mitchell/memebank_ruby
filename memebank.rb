require 'rest_client'
require 'sinatra/base'
require 'json'

# Memebank application class
class Memebank < Sinatra::Application
  enable :sessions
  api_url = 'http://localhost:3000'

  get '/' do
    slim :index, layout: :application
  end

  post '/' do
    user_token = RestClient.post "#{api_url}/user_token",
                                 auth: {
                                   email: params[:email],
                                   password: params[:password]
                                 }
    user_token = JSON.parse user_token, symbolize_names: true
    session[:user_token] = user_token[:jwt]

    redirect to('/home')
  end

  get '/home' do
    retrieve_banks
    @bank_id = @banks[0][:id]
    retrieve_cards

    slim :home, layout: :application do
      slim :view
    end
  end

  get '/home/:id' do
    retrieve_banks
    @bank_id = params[:id].to_i
    retrieve_cards

    slim :home, layout: :application do
      slim :view
    end
  end

  get '/new' do
    retrieve_banks

    slim :home, layout: :application do
      slim :edit, locals: { new_or_edit: 'new', bank_id_if: '' }
    end
  end

  get '/edit/:id' do
    retrieve_banks
    @bank_id = params[:id].to_i

    slim :home, layout: :application do
      slim :edit, locals: { new_or_edit: 'edit', bank_id_if: "/#{@bank_id}" }
    end
  end

  post '/edit/:id' do
    RestClient.put "#{api_url}/banks/#{params[:id]}",
                   { bank: { title: params[:title] } },
                   authorization: 'Authorization: ' \
                                  "Bearer #{session[:user_token]}"

    redirect to("/home/#{params[:id]}")
  end

  private

  def retrieve_banks
    api_url = 'http://localhost:3000'
    @banks = RestClient.get "#{api_url}/banks",
                            authorization: 'Authorization: Bearer ' \
                            "#{session[:user_token]}"
    @banks = JSON.parse @banks, symbolize_names: true
  end

  def retrieve_cards
    api_url = 'http://localhost:3000'
    @cards = RestClient.get "#{api_url}/banks/#{@bank_id}/cards"
    @cards = JSON.parse @cards, symbolize_names: true
  end
end
