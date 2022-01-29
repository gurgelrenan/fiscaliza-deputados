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

require 'rails_helper'

RSpec.describe Deputy, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
