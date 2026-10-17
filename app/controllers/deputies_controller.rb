class DeputiesController < ApplicationController
  def index
    @deputies = Deputy.with_total_expenses
                      .order(:name)
    @total_expenses = Expense.sum(:net_value)
    @expense_count = Expense.count
    @yearly_expenses = Expense.where.not(year: nil).group(:year).sum(:net_value).sort.to_h
    @type_expenses = Expense.joins(:expense_type)
                            .group("expense_types.description")
                            .sum(:net_value)
                            .sort_by { |_description, amount| -amount }
                            .first(6)
    @top_spenders = @deputies.sort_by { |deputy| -deputy.total_expenses.to_f }.first(5)
  end

  def show
    @deputy = Deputy.find(params[:id])
    @max_expense = @deputy.max_expense
    @expense_types = ExpenseType.joins(:expenses)
                                .where(expenses: { deputy_id: @deputy.id })
                                .distinct
                                .order(:description)
    @selected_expense_type_id = @expense_types.find_by(id: params[:expense_type_id])&.id
    @selected_month = params[:month].presence_in(@deputy.expenses.distinct.pluck(:year, :month).filter_map { |year, month| "#{year}-#{month.to_s.rjust(2, '0')}" if year && month })
    sort_columns = {
      "date" => "expenses.date",
      "provider" => "providers.name",
      "expense_type" => "expense_types.description",
      "net_value" => "expenses.net_value"
    }
    @sort = sort_columns.key?(params[:sort]) ? params[:sort] : "date"
    @direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : (@sort == "net_value" ? "desc" : "asc")
    @expenses = @deputy.expenses.includes(:provider, :expense_type).left_joins(:provider, :expense_type)
    @expenses = @expenses.where(expense_type_id: @selected_expense_type_id) if @selected_expense_type_id
    if @selected_month
      year, month = @selected_month.split("-").map(&:to_i)
      @expenses = @expenses.where(year: year, month: month)
      @expenses = @expenses.order(Arel.sql("#{sort_columns.fetch(@sort)} #{@direction.upcase} NULLS LAST"))
    else
      @monthly_totals = @expenses.group(:year, :month).sum(:net_value)
                               .sort_by { |(year, month), _amount| [year || 0, month || 0] }
    end
  end
end
