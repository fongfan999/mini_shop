class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :trackable, :validatable

  has_many :posts, foreign_key: 'buyer_id'

  validates :avatar, presence: true

  mount_uploader :avatar, AvatarUploader

  # Don't store password
  def password_required?
    false
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.remote_avatar_url = auth.info.image
    end
  end

  def profile_avatar
    avatar_url ? avatar_url : remote_avatar_url
  end
end
