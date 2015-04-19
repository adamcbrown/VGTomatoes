require './config/environment'
class Game < ActiveRecord::Base
  has_many :reviews
end