class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  
  has_many :friendships
  has_many :friends, through: :friendships
  
  def full_name
    return "#{first_name} #{last_name}".strip if (last_name || first_name)
    "Anonymous"
  end
  
  def can_add_stock?(ticker_name)
    under_stock_limit? && !stock_already_added?(ticker_name)
  end
  
  def under_stock_limit?
    user_stocks.count < 10
  end
  
  def stock_already_added?(ticker_name)
    stock = Stock.find_by_ticker ticker_name
    return false unless stock
    user_stocks.where(stock_id: stock.id).exists?      
  end
  
  def not_friends_with?(friend_id)
    friendships.where(friend_id: friend_id).empty?
  end
  
  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end
  
  def self.search(param) 
    return User.none if param.blank? 
    
    param.strip!
    param.downcase!
    
    matches('first_name', param) + matches('last_name', param) + matches('email', param)
  end
  
  def self.matches(field_name, param)
    User.where("#{field_name} like ?", "%#{param}%")
  end
end
