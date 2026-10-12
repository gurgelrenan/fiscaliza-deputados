# == Schema Information
#
# Table name: deputies
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  cpf             :string
#  deputy_id       :integer
#  legislature_id  :integer
#  state           :string(2)
#  political_party :string
#  photo_url       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :deputy do
    sequence(:name) { |n| "Deputado #{n}" }
    sequence(:deputy_id) { |n| n }
    legislature_id { 57 }
    state { 'CE' }
    political_party { 'TEST' }
    photo_url { 'https://example.com/deputy.jpg' }
  end
end
