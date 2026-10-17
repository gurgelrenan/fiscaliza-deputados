require 'rails_helper'

RSpec.describe 'Deputies', type: :request do
  it 'renders an empty home page' do
    get root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Fiscaliza Deputados')
  end

  it 'lists deputies alphabetically and shows net expense totals' do
    zoe = create(:deputy, name: 'Zoe')
    ana = create(:deputy, name: 'Ana')
    create(:expense, deputy: ana, net_value: 100)
    create(:expense, deputy: ana, net_value: 25.50)
    create(:expense, deputy: zoe, net_value: 50)

    get deputies_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("R$\u00a0125,50", deputy_path(ana))
    expect(response.body.index('Ana')).to be < response.body.index('Zoe')
  end

  it 'shows the largest expense and links monthly totals to expense details' do
    expense = create(:expense, net_value: 250.75)
    create(:expense, deputy: expense.deputy, month: 2, date: Date.new(2022, 2, 15), net_value: 100)
    get deputy_path(expense.deputy)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("R$\u00a0250,75", expense.document_url, 'Janeiro/2022', 'Fevereiro/2022')
    month_link = Nokogiri::HTML(response.body).at_css('a.month-table__link')
    expect(month_link.text).to eq('Janeiro/2022')

    get month_link['href']

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("R$\u00a0250,75", expense.provider.name, expense.document_url, '15/01/2022')
    expect(response.body).not_to include('15/02/2022')
  end

  it 'shows an empty state for a deputy without expenses' do
    get deputy_path(create(:deputy))
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Nenhuma despesa cadastrada.')
  end

  it 'returns 404 for an unknown deputy' do
    get deputy_path(id: 0)
    expect(response).to have_http_status(:not_found)
  end

  it 'exposes the Rails health check' do
    get rails_health_check_path
    expect(response).to have_http_status(:ok)
  end
end
