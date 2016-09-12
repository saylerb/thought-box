FactoryGirl.define do
  sequence(:email) { |n| "#{n}@example.com" }

  factory :user do
    email
    password "password"
    password_confirmation "password"
  end

  sequence(:title) { |n| "#{n} Link Title" }

  factory :link do
    title 
    url "https://www.turing.io/"
    user
  end
end
