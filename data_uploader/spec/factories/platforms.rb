FactoryBot.define do
  factory :platform, class: 'DataUploader::Platform' do
    sequence(:name) { |n| "platform{n}" }
  end
end
