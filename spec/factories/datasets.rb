FactoryBot.define do
  factory :dataset do
    sequence(:external_id) { |n| "dataset-#{n}" }
    sequence(:title)       { |n| "Dataset Title #{n}" }
    authors  { ["John Doe"] }
    keywords { ["science"] }
  end
end