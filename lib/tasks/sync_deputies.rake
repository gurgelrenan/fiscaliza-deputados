task :sync_deputies => :environment do
  url = 'https://dadosabertos.camara.leg.br/api/v2'

  conn = Faraday.new(
    url: url,
    params: { ordem: 'ASC', ordenarPor: 'nome', siglaUf: 'CE', idLegislatura: '56' },
    headers: { 'Content-Type' => 'application/json' }
  )

  response = conn.get('deputados')

  if response.status == 200
    data = JSON.parse(response.body)

    data['dados'].each do |deputy|
      
    end
  else
    puts 'Erro ao obter dados da Câmara dos Deputados.'
  end
end
