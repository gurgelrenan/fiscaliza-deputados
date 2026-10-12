require 'rails_helper'
require 'rake'

RSpec.describe 'Synchronization tasks' do
  before(:all) do
    Rails.application.load_tasks
  end

  def run_task(name)
    Rake::Task[name].reenable
    Rake::Task[name].invoke
  end

  it 'imports Ceará deputies and avoids duplicates on a repeated run' do
    request = stub_request(:get, 'https://dadosabertos.camara.leg.br/api/v2/deputados')
      .with(query: { ordem: 'ASC', ordenarPor: 'nome', siglaUf: 'CE' })
      .to_return(status: 200, body: { dados: [{
        id: 123, nome: 'Deputado Teste', idLegislatura: 57,
        siglaUf: 'CE', siglaPartido: 'TEST', urlFoto: 'https://example.com/photo.jpg'
      }] }.to_json)

    expect { run_task('sync_deputies') }.to change(Deputy, :count).by(1)
    expect { run_task('sync_deputies') }.not_to change(Deputy, :count)
    expect(Deputy.last).to have_attributes(deputy_id: 123, state: 'CE')
    expect(request).to have_been_requested.twice
  end

  it 'does not create deputies when the API fails' do
    stub_request(:get, /dadosabertos.camara.leg.br/).to_return(status: 503)
    expect { run_task('sync_deputies') }.not_to change(Deputy, :count)
  end

  it 'imports all configured years, follows pagination and avoids duplicate expenses' do
    deputy = create(:deputy)
    row = {
      nomeFornecedor: 'Posto de teste', cnpjCpfFornecedor: '12345678000100',
      tipoDespesa: 'COMBUSTÍVEIS', mes: 1, codDocumento: 100,
      dataDocumento: '2022-01-15', valorDocumento: 30, valorLiquido: 25.75,
      urlDocumento: 'https://example.com/receipt.pdf'
    }
    base = "https://dadosabertos.camara.leg.br/api/v2/deputados/#{deputy.deputy_id}/despesas"
    (2019..2022).each do |year|
      links = year == 2022 ? [{ rel: 'next', href: "#{base}?pagina=2" }] : []
      stub_request(:get, base).with(query: {
        idLegislatura: deputy.legislature_id.to_s, ano: year.to_s,
        ordem: 'asc', ordenarPor: 'mes', itens: '100'
      }).to_return(status: 200, body: { dados: [row.merge(ano: year)], links: links }.to_json)
    end
    next_page = stub_request(:get, "#{base}?pagina=2").to_return(
      status: 200, body: { dados: [row.merge(ano: 2022, codDocumento: 101)], links: [] }.to_json
    )

    expect { run_task('sync_expenses') }.to change(Expense, :count).by(5)
    expect { run_task('sync_expenses') }.not_to change(Expense, :count)
    expect(deputy.expenses.sum(:net_value)).to eq(BigDecimal('128.75'))
    expect(Provider.count).to eq(1)
    expect(ExpenseType.count).to eq(1)
    expect(next_page).to have_been_requested.twice
  end
end
