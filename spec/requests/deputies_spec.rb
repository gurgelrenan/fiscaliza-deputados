require 'rails_helper'

RSpec.describe 'Deputies', type: :request do
  describe 'search' do
    let!(:jose) { create(:deputy, name: 'José Guimarães', political_party: 'PT') }
    let!(:ana) { create(:deputy, name: 'Ana Silva', political_party: 'PDT') }

    before do
      create(:expense, deputy: jose, net_value: 100)
      create(:expense, deputy: jose, net_value: 50)
      create(:expense, deputy: ana, net_value: 25)
    end

    it 'matches partial names without accents or case and preserves expense totals' do
      get deputies_path, params: { q: '  JOSE GUI  ' }

      document = Nokogiri::HTML(response.body)
      expect(document.css('.deputy-name').map(&:text)).to eq(['José Guimarães'])
      expect(document.at_css('input[name="q"]')['value']).to eq('JOSE GUI')
      expect(response.body).to include("R$\u00a0150,00", '1 resultado')
    end

    it 'matches party acronyms' do
      get deputies_path, params: { q: 'pdt' }
      expect(Nokogiri::HTML(response.body).css('.deputy-name').map(&:text)).to eq(['Ana Silva'])
    end

    it 'treats wildcard and SQL characters as literal search text' do
      ["%", "_", "' OR 1=1 --"].each do |query|
        get deputies_path, params: { q: query }
        expect(response).to have_http_status(:ok)
        expect(Nokogiri::HTML(response.body).css('.deputy-name')).to be_empty
        expect(response.body).to include('Nenhum deputado encontrado', 'Limpar busca')
      end
    end

    it 'restores the complete list for blank or malformed search parameters' do
      ['   ', ['José']].each do |query|
        get deputies_path, params: { q: query }
        expect(Nokogiri::HTML(response.body).css('.deputy-name').size).to eq(2)
      end
    end

    it 'escapes search text and exposes counts without putting the query in analytics context' do
      get deputies_path, params: { q: '<script>alert(1)</script>' }
      document = Nokogiri::HTML(response.body)
      expect(response.body).not_to include('<script>alert(1)</script>')
      context = JSON.parse(document.at_css('[data-analytics-page]')['data-analytics-properties'])
      expect(context).to eq('search_active' => true, 'result_count' => 0)
    end
  end

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
