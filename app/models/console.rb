require './config/environment'
class Console < ActiveRecord::Base
  has_many :games
  belongs_to :company
end