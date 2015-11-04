# This sets the basic policies for instruments using
# Pundit for authorization.
class InstrumentPolicy < ApplicationPolicy
  # A Pundit scope, I think
  class Scope < Scope
    # Hmm
    def resolve
      if user.admin?
        scope.all
      elsif user.cls?
        if user.study == "BCS" || user.study == "MCS" || user.study == "NCDS"
          scope.where(study: user.study)
        else
          scope.where("study=? OR study=? OR study=?", "BCS", "MCS", "NCDS")
        end
      elsif user.soton?
        if user.study == "HCS" || user.study == "SWS"
          scope.where(study: user.study)
        else
          scope.where("study=? OR study=?", "HCS", "SWS")
        end
      else
        scope.where(study: user.study)
      end
    end
  end

  # Authorization for action create
  def create?
    user.admin?
  end
  alias batch? create?
 
  # Authorization for action show
  def show?
    user.admin? || user.study == record.study || 
    (user.study == "CLS" && (record.study == "BCS" || record.study == "MCS" || record.study == "NCDS")) ||
    (user.study == "SOTON" && (record.study == "HCS" || record.study == "SWS"))
  end
end
