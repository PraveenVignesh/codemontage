FactoryGirl.define do
  sequence :email do |n|
    "#{Faker::Internet.user_name}#{n}@#{Faker::Internet.domain_name}"
  end

  sequence :user_name do |n|
    "#{Faker::Internet.user_name}#{n}"
  end

  sequence :random_word do |n|
    "#{Faker::Lorem.word}#{n}"
  end

  factory :event do
    short_code { generate(:random_word) }
    name Faker::Lorem.word
  end

  factory :organization do
    name Faker::Company.name
  end

  factory :job do
    title Faker::Lorem.sentence(3)
  end

  factory :project do
    name { generate(:random_word) }
    github_repo { generate(:random_word) }
  end

  factory :user do
    email { generate(:email) }
    password Faker::Internet.password
  end

end