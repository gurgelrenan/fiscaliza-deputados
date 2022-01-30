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

require 'rails_helper'

RSpec.describe ExpenseType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
