require './config/environment'
class Company < ActiveRecord::Base
  has_many :published_games
  has_many :developed_games
  has_many :consoles
  has_many :notable_people
end