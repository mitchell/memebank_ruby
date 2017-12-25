# login and registration route controllers
class Memebank < Sinatra::Application
  get '/' do
    redirect to('/home') if session[:user_token]

    slim :login, layout: :application
  end

  post '/' do
    user_token = RestClient.post "#{@@api_url}/user_token",
                                 auth: { email: params[:email],
                                         password: params[:password] }
    user_token = JSON.parse user_token, symbolize_names: true
    session[:user_token] = user_token[:jwt]

    redirect to('/home')
  end

  get '/logout' do
    session.delete :user_token
    redirect to('/')
  end
end
