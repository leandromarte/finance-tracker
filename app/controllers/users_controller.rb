class UsersController < ApplicationController
  def my_portfolio
    @stocks = current_user.stocks
    @user = current_user
  end
  
  def my_friends
    @friendships = current_user.friends
  end
  
  def search
    
  end
  
  def add_friend
    
  end
end