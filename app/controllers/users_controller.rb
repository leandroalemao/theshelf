class UsersController < Clearance::UsersController
  before_action :handle_disabled_signup, only: [:new, :create]

  def edit
    @wishlist_items = WishlistItem.where(:user_id => current_user.id)
  end

  def create
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :first_name, :last_name, :avatar, :avatar_cache, :remove_avatar)
  end

  def handle_disabled_signup
    redirect_to log_in_path, notice: t('flashes.signup_disabled')
  end

end
