# == Schema Information
#
# Table name: parties
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  auth_statement :string(255)
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :party do
    name "MyString"
    auth_statement "MyString"
    description "MyText"
  end
end
