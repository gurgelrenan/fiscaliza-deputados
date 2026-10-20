require "rails_helper"

RSpec.describe "Analytics", type: :request do
  it "does not load PostHog when disabled" do
    allow(Rails.configuration.x.posthog).to receive(:enabled).and_return(false)

    get root_path

    expect(response.body).not_to include("posthog.init(")
  end

  it "loads the configured project safely and leaves pageview tracking to Turbo" do
    config = Rails.configuration.x.posthog
    allow(config).to receive_messages(enabled: true, project_key: "phc_test</script>", api_host: "https://eu.i.posthog.com")

    get root_path

    expect(response.body).to include("https://eu.i.posthog.com", "capture_pageview: false", "data-turbo-eval=\"false\"")
    expect(response.body).not_to include("phc_test</script>")
    expect(response.body).to include('phc_test\\u003c/script\\u003e')
  end

  it "exposes validated deputy and filter context and marks existing interactions" do
    expense = create(:expense)
    deputy = expense.deputy
    get deputy_path(deputy), params: { month: "2022-01", expense_type_id: expense.expense_type_id }

    document = Nokogiri::HTML(response.body)
    context = JSON.parse(document.at_css("[data-analytics-page]")["data-analytics-properties"])
    expect(context).to include("deputy_id" => deputy.deputy_id, "deputy_name" => deputy.name,
                              "month" => "2022-01", "expense_type_id" => expense.expense_type_id)
    expect(document.css('[data-analytics-feature="sort_expenses"]').size).to eq(4)
    expect(document.css('[data-analytics-feature="open_receipt"]').size).to eq(2)
    expect(document.at_css('form[data-analytics-feature="filter_expenses"]')).to be_present

    get deputy_path(deputy), params: { month: "invalid", expense_type_id: "invalid" }
    context = JSON.parse(Nokogiri::HTML(response.body).at_css("[data-analytics-page]")["data-analytics-properties"])
    expect(context.values_at("month", "expense_type_id")).to eq([nil, nil])
  end
end
