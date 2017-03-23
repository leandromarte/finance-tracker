class UsersController < ApplicationController
  def my_portfolio
    @stocks = current_user.stocks
    @user = current_user
  end
end