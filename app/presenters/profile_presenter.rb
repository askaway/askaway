class ProfilePresenter
  def initialize(user, record)
    @user = user
    @record = record
  end

  def avatar_url(size: nil)
    @record.avatar_url(size: size)
  end

  def edit_url
    if @record.class == User && UserPolicy.new(@user, @record).edit?
      Rails.application.routes.url_helpers.edit_user_path(@record)
    end
  end

  def name
    @record.name
  end

  def description
    if @record.class == Party
      @record.description
    end
  end

  def sections
    if @record.class == Party
      section = ProfileSectionPresenter.new(name: 'spokespeople',
                                            record: @record)
    elsif @record.class == User
      section = ProfileSectionPresenter.new(name: 'questions',
                                            record: @record)
    end
    [section]
  end
end
