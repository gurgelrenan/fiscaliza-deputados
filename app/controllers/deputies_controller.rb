class DeputiesController < ApplicationController
  def index
    @deputies = Deputy.with_total_expenses
                      .order(:name)
  end

  def show
    @deputy = Deputy.find(params[:id])
    @max_expense = @deputy.max_expense
    @expenses = @deputy.expenses.includes(:provider).order(:date)
  end
end
