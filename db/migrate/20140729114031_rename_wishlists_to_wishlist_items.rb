class RenameWishlistsToWishlistItems < ActiveRecord::Migration
  def change
  	rename_table("wishlists", "wishlist_items")
  end
end
