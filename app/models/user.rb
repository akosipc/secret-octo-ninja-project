class User < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, 
                  :last_name, :gender, :avatar_path, :role, :provider, :uid, :username

  def admin?
    role.eql? 'Admin'
  end

  def user?
    role.eql? 'User'
  end
  
  def promote!
    self.update_attributes(role: 'Admin')
  end
  
  def demote!
    self.update_attributes(role: 'User')
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.find_github_for_oauth(auth, user = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first

    unless user

      user = User.new(provider:         auth.provider,
                      uid:              auth.uid,
                      email:            auth.info.email,
                      password:         Devise.friendly_token[0,20],
                      first_name:       auth.extra.raw_info.first_name,
                      last_name:        auth.extra.raw_info.last_name,
                      gender:           auth.extra.raw_info.gender.capitalize!,
                      username:         auth.info.nickname,
                      avatar_path:      auth.info.image,
                      role:             'User')

      user.save

    end

    user
  end
end
