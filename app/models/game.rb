require './config/environment'
class Game < ActiveRecord::Base
  has_many :reviews
  has_many :consoles

  def rating
    rating=0
    reviews.collect do |review|
      rating+=review.rating
    end
    return rating/reviews.size
  end
end