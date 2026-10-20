class DeputiesController < ApplicationController
  def index
    @query = params[:q].is_a?(String) ? params[:q].strip.first(200) : ""
    @deputies = Deputy.with_total_expenses
                      .search(@query)
                      .order(:name)
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
