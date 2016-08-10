class User < ActiveRecord::Base
  add_access_utilities
  belongs_to :person  # this is ok for an optional relationship
  has_and_belongs_to_many :roles
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # note that presence: true doesn't work with booleans (because false is
  # not present)
  validates :notification_list, inclusion: [true, false]
                    
  # do some stuff each time a new user is created
  after_create :after_create_action
                    
  # needed for action_access to control access to specific parts of our site
  # based on user roles. Needs to get all the roles for this user
  def clearance_levels
    roles.pluck(:name)
  end
  
  # a new user has just been created
  # add the user to the user role
  def after_create_action
    roles << Role.find_by(name: "user")
  end
    
  # the name of this user. If there is no Person associated with this User yet,
  # return the email address
  def name
    if !person.nil?
      person.name
    else
      email
    end
  end
  
  # this user's membership status. One of:
  # :new    -- never been a member
  # :former -- has been a member, but not in the current or previous session
  #            provided the current session hasn't started yet
  # :member -- member in the current session or the last session if there is no
  #            current session
  def membership
    if person.nil? then :new
    else
      cuco_sessions = person.family.cuco_sessions
      if cuco_sessions.empty? then :new
      elsif cuco_sessions.include? CucoSession.current then :member
      elsif CucoSession.current.nil? and cuco_sessions.include? CucoSession.last then :member
      else :former
      end
    end
  end

  # needed for authorization of a google account (so we can update a google
  # calendar, for example)
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.find_by(email: data.email)
    if user
      user.provider = access_token.provider
      user.uid = access_token.uid
      user.token = access_token.credentials.token
      user.save
      user
    else
      redirect_to new_user_registration_path, notice: "Error."
    end
  end
end
