class InstrumentPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(study: user.study)
      end
    end
  end

  def create?
    user.admin?
  end
  alias batch? create?

  def show?
    user.admin? || user.study == record.study || 
    (user.study == "CLS" && (record.study == "BCS" || record.study == "MCS" || record.study == "NCDS")) ||
    (user.study == "SOTON" && (record.study == "HCS" || record.study == "SWS"))
  end
end
