class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  def admin
    return study == "Admin"
  end
  alias admin? admin 
  def cls
    return study == "CLS" || study == "BCS" || study == "MCS" || study == "NCDS"
  end
  alias cls? cls
  def soton
    return study == "SOTON" || study == "HCS" || study == "SWS"
  end
  alias soton? soton
end
