# frozen_string_literal: true

FactoryBot.define do
  factory :heading, class: Heading do
    sequence(:heading) { |n| "heading#{n}" }
  end
end
