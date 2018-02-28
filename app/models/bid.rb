class Bid < ApplicationRecord
  belongs_to :project
  belongs_to :user, :class_name => 'User', :foreign_key => 'initiator_id'
  belongs_to :resolution
  has_many :bid_details

  after_commit :create_bid_details, on: :create

  validates_presence_of :bid_percentage, :project_id, :resolution_id, :initiator_id
  validates :bid_percentage, numericality: { only_float: true, greater_than: 0.0, less_than: 100.0 }

  store_accessor :variables, :user_id, :bid_percentage, :vesting_period

  def create_bid_details
  	project = self.project
  	project.users.each do |u|
  		BidDetail.create(bid_id: self.id, user_id: u.id)
  	end
  end
end
