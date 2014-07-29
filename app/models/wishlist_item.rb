class WishlistItem <ActiveRecord::Base
	belongs_to :user
	belongs_to :book

	validates_presence_of :user, :book
end