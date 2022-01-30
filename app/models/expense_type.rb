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

class ExpenseType < ApplicationRecord
  belongs_to :expense
end
