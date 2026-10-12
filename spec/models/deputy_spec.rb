require 'rails_helper'

RSpec.describe Deputy, type: :model do
  describe '.with_total_expenses' do
    it 'sums net expenses separately for each deputy' do
      deputy = create(:deputy)
      other = create(:deputy)
      create(:expense, deputy: deputy, net_value: 10.25, value: 20)
      create(:expense, deputy: deputy, net_value: 15.50, value: 30)
      create(:expense, deputy: other, net_value: 100)

      totals = described_class.with_total_expenses.index_by(&:id)
      expect(totals.fetch(deputy.id).total_expenses).to eq(BigDecimal('25.75'))
      expect(totals.fetch(other.id).total_expenses).to eq(100)
    end
  end

  describe '#max_expense' do
    it 'returns the highest net expense belonging to the deputy' do
      deputy = create(:deputy)
      create(:expense, deputy: deputy, net_value: 10)
      largest = create(:expense, deputy: deputy, net_value: 200)
      create(:expense, net_value: 500)

      expect(deputy.max_expense).to eq(largest)
    end

    it 'returns nil when no expenses exist' do
      expect(create(:deputy).max_expense).to be_nil
    end
  end
end
