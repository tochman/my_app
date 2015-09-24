require 'sinatra/base'
require 'sinatra/form_helpers'
require 'sinatra/flash'
require 'tilt/erb'
require 'data_mapper'
require './lib/link'
require './lib/tag'
require './lib/user'
#require 'pry'


class MyApp < Sinatra::Base
  set :views, proc { File.join(root, '..', 'views') }
  enable :sessions
  set :session_secret, '123454321'
  use Rack::Session::Pool
  env = ENV['RACK_ENV'] || 'development'

  DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/my_app_#{env}")

  DataMapper::Model.raise_on_save_failure = true

  DataMapper.finalize

  DataMapper.auto_upgrade!

  helpers Sinatra::FormHelpers
  register Sinatra::Flash
  before do
    @user = User.get(session[:user_id]) unless is_user?
  end

  register do
    def auth (type)
      condition do
        redirect '/login' unless send("is_#{type}?")
      end
    end
  end

  helpers do
    def is_user?
      @user != nil
    end

    def current_user
      @user
    end
  end

  #binding.pry

  get '/' do
    @links = Link.all
    erb :index
  end

  get '/tags/:tag' do
    tag = Tag.first(title: params[:tag])
    @links = tag.links
    @current_tag = tag[:title]
    erb :index
  end

  get '/destroy/:id', auth: :user do
    link = Link.get(params[:id])
    link.destroy!
    redirect '/'
  end

  get '/sign-up' do
    erb :sign_up
  end

  post '/register' do
    begin
      user_params = params[:user]
      @user = User.create(email: user_params[:email], password: user_params[:password], password_confirmation: user_params[:password_confirmation])
      session[:user_id] = @user.id
      flash[:notice] = "Welcome #{@user.email}!"
      @links = Link.all
      erb :index
    rescue
      flash[:notice] = 'Could not register you... Check your input.'
      redirect '/sign-up'
    end
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    #binding.pry
    user_params = params[:user]
    @user = User.authenticate(user_params[:email], user_params[:password])
    session[:user_id] = @user.id
    @links = Link.all
    flash[:notice] = "Welcome #{@user.email}!"
    redirect '/'
  end

  get '/logout' do
    session[:user_id] = nil
    flash[:notice] = "Goodbye!"
    redirect '/'
  end

  get '/links/new', auth: :user do
    erb :'links/new'
  end

  post '/links/create', auth: :user do
    #binding.pry
    link_params = params[:link]
    link = Link.create(title: link_params[:title],
                       url: link_params[:url],
                       description: link_params[:description],
                       created_at: Time.now,
                       user_id: @user.id)
    tags = link_params[:tags].split(',')
    tags.each do |tag|
      link.tags << Tag.first_or_create(title: tag.strip)
      link.save
    end
    flash[:notice] = "Created link for #{link[:title]}!"
    redirect '/'
  end


  run! if app_file == $0
end
