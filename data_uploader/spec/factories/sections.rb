FactoryBot.define do
  factory :section, class: 'DataUploader::Section' do
    association :platform
    sequence(:name) { |n| "section{n}" }
  end
end
