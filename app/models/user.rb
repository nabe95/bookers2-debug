class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  # フォロー
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  #DM機能
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  # ページ閲覧数機能
  has_many :view_counts, dependent: :destroy
  
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50}
  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  #フォローする時
  def follow(user)
    relationships.create(followed_id: user.id)
  end
  
  #フォローを外す時
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end
  
  #フォローの確認
  def following?(user)
    following.include?(user)
  end
  
  #検索機能
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?','%' + content)
    else
      User.where('name LIKE ?','%' + content + '%')
    end
  end
end