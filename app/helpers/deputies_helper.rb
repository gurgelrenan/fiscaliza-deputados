module DeputiesHelper
  MONTH_NAMES = %w[Janeiro Fevereiro Março Abril Maio Junho Julho Agosto Setembro Outubro Novembro Dezembro].freeze

  def deputy_analytics_properties(deputy)
    { deputy_id: deputy.deputy_id, deputy_name: deputy.name, political_party: deputy.political_party }
  end

  def analytics_feature(feature, properties = {})
    { analytics_feature: feature, analytics_properties: properties.to_json }
  end

  def expense_month_label(year, month)
    return "Período não informado" unless year && month && month.between?(1, 12)

    "#{MONTH_NAMES[month - 1]}/#{year}"
  end
end
