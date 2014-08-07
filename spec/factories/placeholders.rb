# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :placeholder do
    uploaded_avatar { StringIO.new('test.jpeg') }
    uploaded_avatar_content_type { 'image/jpeg' }
  end
end
