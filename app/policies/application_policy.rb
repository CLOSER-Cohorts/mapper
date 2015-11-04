# This sets the basic policies for the application using
# Pundit for authorization.
class ApplicationPolicy
  # I am not sure what this does
  attr_reader :user, :record

  # I need help
  def initialize(user, record)
    @user = user
    @record = record
  end

  # Sets the basic authorization for index
  def index?
    false
  end

  # Sets the basic authorization for show
  def show?
    scope.where(:id => record.id).exists?
  end

  # Sets the basic authorization for create
  def create?
    false
  end

  # Sets the basic authorization for new
  def new?
    create?
  end

  # Sets the basic authorization for update
  def update?
    false
  end

  # Sets the basic authorization for edit
  def edit?
    update?
  end

  # Sets the basic authorization for destroy
  def destroy?
    false
  end

  # Not sure what this does either
  def scope
    Pundit.policy_scope!(user, record.class)
  end

  # What is this for?
  class Scope
    # Hmmm
    attr_reader :user, :scope

    # Help me
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # Really lost now
    def resolve
      scope
    end
  end
end
