# card route controllers
class Memebank < Sinatra::Application
  get '/card/:id' do
    retrieve_banks
    @card = RestClient.get "#{@@api_url}/cards/#{params[:id]}"
    @card = JSON.parse @card, symbolize_names: true
    @bank_id = @card[:bank_id]

    slim :home, layout: :application, locals: { current_view: :card } do
      slim :card
    end
  end
end
