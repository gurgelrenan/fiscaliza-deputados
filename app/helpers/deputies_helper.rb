module DeputiesHelper
  MONTH_NAMES = %w[Janeiro Fevereiro Março Abril Maio Junho Julho Agosto Setembro Outubro Novembro Dezembro].freeze

  def expense_month_label(year, month)
    return "Período não informado" unless year && month && month.between?(1, 12)

    "#{MONTH_NAMES[month - 1]}/#{year}"
  end
end
