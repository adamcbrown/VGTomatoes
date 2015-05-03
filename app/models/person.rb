require './config/environment'
class Person < ActiveRecord::Base
  has_many :composed_games
  belongs_to :company
end