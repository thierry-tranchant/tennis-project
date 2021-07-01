class PronoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.username == record.user.username
  end

  def show?
    true
  end

  def index?
    true
  end
end
