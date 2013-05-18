# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username 'Testy1'
    first_name 'Testy'
    last_name 'McUserton'
    email 'example@example.com'
    password 'changeme'
  end
end
