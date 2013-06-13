class Entry < ActiveRecord::Base
  WINNERS = 1

  attr_accessible :email
  validates :email, presence: true, uniqueness: true

  def self.chance_to_win
    if Entry.count < WINNERS
      "100%"
    else
      "#{((1.0/Entry.count)*100).to_i}%"
    end
  end
end
