class LeaguePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.includes(:users).where(users: { id: user.id })
    end
  end

  def create?
    true
  end
end
