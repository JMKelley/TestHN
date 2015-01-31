class LinkPolicy < Struct.new(:user, :link)
  def owned
    link.user_id == user.id
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    new?
  end

  def new?
    true
  end

  def update?
    edit?
  end

  def edit?
    owned
  end

  def destroy?
    owned
  end
end