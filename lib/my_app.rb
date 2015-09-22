require 'sinatra/base'
require 'sinatra/form_helpers'
require 'tilt/erb'
require 'data_mapper'
#require 'dm-postgres-adapter'
require './lib/link'
require './lib/tag'
require './lib/user'
require 'pry'



class MyApp < Sinatra::Base
  set :views, proc {File.join(root, '..', 'views')}
  enable :sessions
  set :session_secret, '123454321'
  use Rack::Session::Pool
  env = ENV['RACK_ENV'] || "development"
  helpers Sinatra::FormHelpers
   
  DataMapper.setup(:default, "postgres://localhost/my_app_#{env}")
  DataMapper::Model.raise_on_save_failure = true
   
  DataMapper.finalize

  DataMapper.auto_upgrade!
  #binding.pry
   
  get '/' do 
    @links = Link.all
    erb :index
  end
  
  get '/sign-up' do
    erb :sign_up
  end
  
  post '/register' do 
    user_params = params[:user]
    @user = User.create(email: user_params[:email], password: user_params[:password], password_confirmation: user_params[:password_confirmation])
    unless @user.nil?
      @links = Link.all
      erb :index
    else
      erb :sign_up
    end
  end
  

  # start the server if ruby file executed directly
  run! if app_file == $0
end
