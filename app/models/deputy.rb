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

class Deputy < ApplicationRecord
  has_many :expenses
end
