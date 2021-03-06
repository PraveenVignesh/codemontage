class User < ActiveRecord::Base
  before_save :encrypt_password
  after_create :create_profile

  # Include default devise modules. Others available are:
  # :confirmable,:lockable, and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :trackable, :validatable

  attr_protected :is_admin

  has_many :event_registrations
  has_many :events, through: :event_registrations

  has_many :favorite_projects
  has_many :favorites, through: :favorite_projects, source: :project
  has_many :projects, through: :favorite_projects

  has_many :services
  has_one :profile, class_name: 'UserProfile'
  delegate :gravatar_email, :headline, :is_coder, :name, :represents_org, :represents_team, :cause_list, :technology_list, :email_news, :email_training, to: :profile

  validates_presence_of :password, on: :create # will only run on account creation

  validates_presence_of :email    # will run in all validation contexts
  validates_uniqueness_of :email  # will run in all validation contexts

  # Location from IP
  geocoded_by :current_sign_in_ip
  reverse_geocoded_by :latitude, :longitude, address: :location
  after_validation :geocode, :reverse_geocode, if: :current_sign_in_ip_changed?

  scope :with_github, where(Service.where('services.user_id = users.id AND provider = ?', 'github').exists)

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def has_github
    services.where(provider: 'github').exists?
  end

  protected

  def create_profile
    @profile = UserProfile.new
    @profile.user_id = id
    @profile.save
  end
end
