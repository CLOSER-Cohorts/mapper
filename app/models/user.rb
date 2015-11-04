# The user model represents a user account within Mapper.
#
# User accounts are primarily being used for authorization and
# authentication.
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

  # Returns true if the user is part of any of the CLS studies
  # or a member of the CLS group.
  def cls
    return study == "CLS" || study == "BCS" || study == "MCS" || study == "NCDS"
  end
  alias cls? cls

  # Returns true if the user is part of any of the Southampton
  # studies or a member of the SOTON group.
  def soton
    return study == "SOTON" || study == "HCS" || study == "SWS"
  end
  alias soton? soton
end
