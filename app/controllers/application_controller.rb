require './config/environment'
require 'bcrypt'
require 'date'
require_relative '../models/user.rb'
require_relative '../models/console.rb'
require_relative '../models/game.rb'
require_relative '../models/company.rb'
require_relative '../models/review.rb'

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

    def scoreToText(num)
      num=num.to_i
      if num==0
        return "Horrible"
      elsif num==1
        return "Bad"
      elsif num==2
        return "OK"
      elsif num==3
        return "Good"
      elsif num==4
        return "Great"
      elsif num==5
        return "Amazing"
      else
        return "?"
      end
    end
  end

  get '/' do
    erb :index
  end

  get '/game' do
    @game=Game.find_by_id(params[:id])
    erb :game
  end

  get '/create_game' do
    if(session[:user_id]==User.all[0].id) #Admin account
      @consoles=Console.all
      erb :create_game
    else
      erb "You do not have access to this page"
    end
  end

  get '/create_console' do
    if(session[:user_id]==User.all[0].id) #Admin account
      @companies=Company.all
      erb :create_console
    else
      erb "You do not have access to this page"
    end
  end

  get '/create_review' do
    if user!=nil
      @game=Game.find(params[:game].to_i)
      canWrite=true
      user.reviews.each do |review|
        if review.game==@game
          canWrite=false
        end
      end

      if canWrite
        erb :create_review
      else
        erb "You already wrote a review for this game"
      end
    else
      redirect '/login'
    end
  end

  get '/user' do
    @viewed_user=User.find_by_id(params[:id])
    if(@viewed_user==nil)
      erb :error
    else
      @reviews=Review.where(:user==@viewed_user).order("id desc")
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

  get '/search' do
    @search=params[:search]
    @order=params[:order]
    unsorted_results=Game.where('name LIKE ?', "%#{params[:search]}%").limit(20)
    if params[:order]=="score"
      unsorted_results=unsorted_results.sort { |a,b| a <=> b }.reverse
    else
      unsorted_results=unsorted_results.reorder("id desc")
    end
    @results=unsorted_results
    erb :search
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

  post '/search' do
    redirect "/search?search=#{params[:search]}&order=recent"
  end

  post "/submit_game" do
    game=Game.new(:name=>params[:name], :description=>params[:description], :img_url=>params[:img], :ESRB_rating=>params[:ESRB_rating], :release_date=>params[:release_date])
    Console.all.each do |console|
      if params["console-#{console.abbreviation}".gsub(" ","_").to_sym]
        game.consoles<<console
        console.games<<game
      end
    end
    game.save

    redirect '/game?id='+game.id.to_s
  end

  post "/submit_console" do
    console=Console.new(:name=>params[:name], :abbreviation=>params[:abbreviation])
    co=Company.find_by(name: params[:name])
    console.company=co
    co.consoles<<console
    console.save
  end

  post "/submit_review" do
    params[:description]=params[:description].gsub('<', '').gsub('>', '')
    review=Review.new(:rating=>(params[:rating].to_i), :description=>params[:description])
    game=Game.find(params[:game_id].to_i)
    review.user=user
    review.game=game
    game.reviews<<review
    user.reviews<<review
    review.save
    game.save
    user.save
    redirect '/game?id='+game.id.to_s
  end
end
