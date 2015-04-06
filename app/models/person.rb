class Person < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :group_people
  has_many :groups, through: :group_people

  def self.omniauth(auth)
    dummy = Devise.friendly_token[0,20]

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider   = auth.provider 
      user.uid        = auth.uid
      user.name       = auth.info.name
      user.image      = auth.info.image
      user.token      = auth.credentials.token
      user.email      = auth.info.email || "#{dummy}@rudolph.com"
      user.expires_at = Time.at(auth.credentials.expires_at)
      user.password   = dummy
      user.save!
    end
  end

  def apply_omniauth(auth)
    dummy = Devise.friendly_token[0,20]

    update_attributes(provider: auth.provider, 
                      uid: auth.uid, 
                      name: auth.info.name, 
                      image: auth.info.image, 
                      token: auth.credentials.token, 
                      email: auth.info.email || email || "#{dummy}@rudolph.com",
                      expires_at: Time.at(auth.credentials.expires_at),
                      password: dummy)
  end

  def invited?
    !invitation_token.nil? && invitation_accepted_at.nil?
  end

  def error_messages
    errors.full_messages.join(' ,')
  end

end
