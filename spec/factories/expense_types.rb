# == Schema Information
#
# Table name: expense_types
#
#  id              :integer          not null, primary key
#  expense_type_id :integer
#  description     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :expense_type do
    description { 'COMBUSTÍVEIS E LUBRIFICANTES' }
  end
end
