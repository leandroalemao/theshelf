class WishlistItemsController <ApplicationController
	before_action :authorize


	def create
		book = Book.find(params[:book_id])
		WishlistItem.create(book: book, user: current_user)
		redirect_to root_path, notice: 'Success'
	end

	def destroy
		WishlistItem.find(params[:id]).destroy
		redirect_to root_path, notice: 'Success'
	end
end