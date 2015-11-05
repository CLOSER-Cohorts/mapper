# The user model represents a user account within Mapper.
#
# User accounts are primarily being used for authorization and
# authentication.
#
# ==== Attributes
# * email - User email address
# * password - User password used for login authentication
# * study - User group (badly named)
#
#     u = User.new
#     u.email = 'example@closer.ac.uk'
#     u.password = 'supersecret'
#     u.study = 'Admin'
#     u.save! 
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Returns true if the user is a member of the admin group.
  def admin
    return study == "Admin"
  end
  alias admin? admin 
end
