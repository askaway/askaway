class PlaceholderPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def create?
    user.try(:is_admin?)
  end

  def new?
    create?
  end

  def upload_avatar?
    create?
  end

  def new_avatar?
    create?
  end
end
