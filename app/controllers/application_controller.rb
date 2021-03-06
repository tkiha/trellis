class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_out_path_for(resource)
    home_path
  end

  private
  def set_board
    @board = current_user.boards.find(params[:board_id]||params[:id])
  end

  def set_list
    @list = @board.lists.find(params[:list_id]||params[:id])
  end

  def set_card
    @card = @list.cards.find(params[:card_id]||params[:id])
  end
end
