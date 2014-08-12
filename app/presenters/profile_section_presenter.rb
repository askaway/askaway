class ProfileSectionPresenter
  attr_reader :name, :record

  def initialize(name: nil, record: nil)
    @name = name
    @record = record
  end

  def template_path
    "profiles/#{record.class.name.underscore.pluralize}/#{name}"
  end
end
