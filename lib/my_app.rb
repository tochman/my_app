require 'sinatra/base'
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
   
   DataMapper.setup(:default, "postgres://localhost/my_app_#{env}")
   DataMapper::Model.raise_on_save_failure = true
   
   DataMapper.finalize

   DataMapper.auto_upgrade!
   #binding.pry
   
  get '/' do
    
    @links = Link.all
    erb :index
  end
  

  # start the server if ruby file executed directly
  run! if app_file == $0
end
