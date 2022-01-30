# == Schema Information
#
# Table name: expenses
#
#  id               :integer          not null, primary key
#  deputy_id        :integer          not null
#  expense_type_id  :integer          not null
#  provider_id      :integer          not null
#  year             :integer
#  month            :integer
#  document_code    :integer
#  document_number  :string
#  document_type    :string
#  document_type_id :integer
#  date             :date
#  value            :decimal(10, 2)
#  net_value        :decimal(10, 2)
#  gloss_value      :decimal(10, 2)
#  document_url     :string
#  refund_number    :string
#  batch_code       :integer
#  tranche          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_expenses_on_deputy_id        (deputy_id)
#  index_expenses_on_expense_type_id  (expense_type_id)
#  index_expenses_on_provider_id      (provider_id)
#

require 'rails_helper'

RSpec.describe Expense, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
