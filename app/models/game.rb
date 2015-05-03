  require './config/environment'
class Game < ActiveRecord::Base
  has_many :reviews
  has_many :consoles
  has_many :developers
  has_many :publishers
  has_many :composers
  belongs_to :series

  #Rating scales on a 0 to a 5
  def rating
    if reviews.size ==0
      return nil
    end
    rating=0
    reviews.each do |review|
      rating+=review.rating
    end
    return (rating*1.0/reviews.size).round(2)
  end
end