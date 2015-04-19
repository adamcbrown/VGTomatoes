require './config/environment'
class Review < ActiveRecord::Base
  belongs_to :user, :game
end