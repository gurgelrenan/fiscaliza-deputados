# == Schema Information
#
# Table name: providers
#
#  id         :integer          not null, primary key
#  name       :string
#  cpf_cnpj   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :provider do
    name { 'Fornecedor de teste' }
    sequence(:cpf_cnpj) { |n| n.to_s.rjust(14, '0') }
  end
end
