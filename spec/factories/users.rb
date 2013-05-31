# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    username 'Testy1'
    email 'example@example.com'
    password 'changeme'
  end
end
