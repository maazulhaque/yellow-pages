# frozen_string_literal: true

FactoryBot.define do
  factory :member, class: Member do
    sequence(:name) { |n| "name#{n}" }
    url { "https://www.google.com/" }

    trait :with_headings do
      after :create do |m|
        create_list :heading, 2, member: m
      end
    end
  end
end
