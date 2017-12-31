# card route controllers
class Memebank < Sinatra::Application
  get '/card/:id' do
    check_session_retrieve_banks
    @card = RestClient.get "#{@@api_url}/cards/#{params[:id]}"
    @card = JSON.parse @card, symbolize_names: true
    @bank_id = @card[:bank_id]

    slim :home, layout: :application, locals: { current_view: :card } do
      slim :card
    end
  end

  get '/add_card/:bank_id' do
    check_session_retrieve_banks
    @bank_id = params[:bank_id].to_i

    slim :home, layout: :application, locals: { current_view: :none } do
      slim :add_card
    end
  end

  post '/add_card/:bank_id' do
    @card = RestClient.post "#{@@api_url}/banks/#{params[:bank_id]}/cards",
                            { card: { src: params[:src] } },
                            authorization: 'Authorization: Bearer ' \
                            "#{session[:user_token]}"
    @card = JSON.parse @card, symbolize_names: true

    redirect to("/card/#{@card[:id]}")
  end

  get '/delete_card/:id/:bank_id' do
    RestClient.delete "#{@@api_url}/cards/#{params[:id]}",
                      authorization: 'Authorization: Bearer ' \
                      "#{session[:user_token]}"

    redirect to("/home/#{params[:bank_id]}")
  end
end
