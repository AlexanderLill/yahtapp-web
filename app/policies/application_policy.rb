class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    user.admin? or record.user_id == user.id
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    user.admin? or record.user_id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? or record.user_id == user.id
  end

  def show_trash?
    user.admin?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
