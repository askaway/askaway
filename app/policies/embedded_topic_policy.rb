class EmbeddedTopicPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def create?
    user.can_embed?
  end

  def index?
    user.can_embed?
  end

  def new?
    user.can_embed?
  end

  def edit?
    user.can_embed?
  end

  def update?
    user.can_embed?
  end
end
