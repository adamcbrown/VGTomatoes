require './config/environment'
require 'pry'
require 'bcrypt'
require 'date'
require_relative '../models/user.rb'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
      enable :sessions
    set :session_secret, 'flatironrulz'
  end

  helpers do
    def user
      return User.find_by_id(session[:user_id])
    end
  end

  get '/' do
    erb :index
  end

  get '/user' do
    @viewed_user=User.find_by_id(params[:id])
    if(@viewed_user==nil)
      erb :error
    else
      erb :user
    end
  end

  get '/register' do
    @error=session[:error]
    @error_msg=session[:error_msg]
    session[:error]=nil
    session[:error_msg]=nil

    if session[:store_dob==nil]
      session[:store_dob]=""
      session[:store_email]=""
      session[:store_username]=""
    else
      @username=session[:store_username]
      @email=session[:store_email]
      @dob=session[:store_dob]
      session[:store_dob]=""
      session[:store_email]=""
      session[:store_username]=""
    end

    erb :register
  end

  get '/login' do
    @error_msg=session[:error_msg]
    session[:error_msg]=nil

    erb :login
  end

  post '/login_user' do
    user=User.find_by(:email=>params[:email]).try(:authenticate, params[:password])
    if(user==false)#invalid email or password
      session[:error_msg]="Your email or password is invalid"
      redirect '/login'
    else
      session[:user_id]=user.id
      redirect '/user?id='+user.id.to_s
    end
  end

  post '/logout' do
    session[:user_id]=nil
    redirect '/'
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  post '/register_user' do
    valid_date=false
    begin
      Date.strptime(params[:date_of_birth], '%m/%d/%Y')==nil
      valid_date=true
    rescue ArgumentError
    end
    if !valid_date #Invalid DOB
      session[:error]="date_of_birth"
      session[:error_msg]="This is not a valid date of birth"
    elsif User.where(:username=>params[:username]).size!=0 #Username taken
      session[:error]="username"
      session[:error_msg]="This username is already taken"
    elsif User.where(:email=>params[:email]).size!=0 #Email taken
      session[:error]="email"
      session[:error_msg]="This email address is already taken"
    elsif (params[:email] =~ VALID_EMAIL_REGEX)==nil #Invalid Email
      session[:error]="email"
      session[:error_msg]="This email address is invalid"
    else
      user=User.new(:username=>params[:username], :password=>params[:password],
              :password_confirmation=>params[:password_confirmation],
              :email=>params[:email])
      if user.save
        session[:user_id]=user.id
        redirect '/user?id='+user.id.to_s
      else
        session[:error]="password password_confirmation"
        session[:error_msg]="Your password or password confirmation has an error"
      end
    end
    session[:store_username]=params[:username]
    session[:store_dob]=params[:date_of_birth]
    session[:store_email]=params[:email]
    redirect '/register' #if there is an error go back to the register page
  end
end
