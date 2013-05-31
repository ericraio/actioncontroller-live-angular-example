# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    body "MyString"
    headline "My Headline"
    slug "my-headline"
  end
end
