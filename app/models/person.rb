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

  def photo_by_size(size)
    uid ? "http://graph.facebook.com/#{uid}/picture?type=#{size}" : 'http://profile.ak.fbcdn.net/static-ak/rsrc.php/v2/yo/r/UlIqmHJn-SK.gif'
  end

  def status
    invited? ? 'pending' : 'active'
  end

  def can_be_invited?
    invitation_created_at.nil? || Time.now - invitation_created_at > 1.minute
  end

  def is_admin?(group)
    self == group.admin
  end

  def is_member?(group)
    group.people.include?(self)
  end

  def error_messages
    errors.full_messages.join(' ,')
  end

end
