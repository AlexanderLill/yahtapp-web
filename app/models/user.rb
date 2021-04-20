class User < ApplicationRecord
  has_many :habits
  has_many :goals
  has_many :occurrences, through: :habits
  has_many :reflections, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  validates :username, uniqueness: { case_sensitive: false }, presence: true, allow_blank: false, format: { with: /\A[a-zA-Z0-9\ } }._]+\z/ }

  attr_writer :login

  enum role: [:subscriber,:researcher,:admin]

  serialize :reflection_on, Array
  serialize :reflection_at, Array

  after_initialize :default_values

  def default_values
    self.reflection_on = [:friday]
    self.reflection_at = ["17:00"]
  end

  # used by devise to allow login via username or email
  def login
    @login || self.username || self.email
  end

  # required so devise can find the user based on the username and the email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

end
