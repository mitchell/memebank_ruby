# banks route controllers
class Memebank < Sinatra::Application
  get '/home' do
    check_session_retrieve_banks
    @bank_id = @banks[0][:id]
    retrieve_cards

    slim :home, layout: :application, locals: { current_view: :bank } do
      slim :view
    end
  end

  get '/home/:id' do
    check_session_retrieve_banks
    @bank_id = params[:id].to_i
    retrieve_cards

    slim :home, layout: :application, locals: { current_view: :bank } do
      slim :view
    end
  end

  get '/new' do
    check_session_retrieve_banks

    slim :home, layout: :application, locals: { current_view: :none } do
      slim :edit, locals: { new_or_edit: 'new', bank_id_if: '' }
    end
  end

  get '/edit/:id' do
    check_session_retrieve_banks
    @bank_id = params[:id].to_i

    slim :home, layout: :application, locals: { current_view: :none } do
      slim :edit, locals: { new_or_edit: 'edit', bank_id_if: "/#{@bank_id}" }
    end
  end

  post '/edit/:id' do
    RestClient.put "#{@@api_url}/banks/#{params[:id]}",
                   { bank: { title: params[:title] } },
                   authorization: 'Authorization: ' \
                                  "Bearer #{session[:user_token]}"

    redirect to("/home/#{params[:id]}")
  end
end
