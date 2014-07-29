class CreateWishlist < ActiveRecord::Migration
  def change
    create_table :wishlists do |t|
    	t.references :user, null: false
      	t.references :book, null: false

      	t.timestamps
    end
  end
end
