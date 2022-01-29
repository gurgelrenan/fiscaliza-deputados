task :sync_deputies => :environment do
  url = 'https://dadosabertos.camara.leg.br/api/v2'

  conn = Faraday.new(
    url: url,
    params: { ordem: 'ASC', ordenarPor: 'nome', siglaUf: 'CE' },
    headers: { 'Content-Type' => 'application/json' }
  )

  response = conn.get('deputados')

  if response.status == 200
    data = JSON.parse(response.body)

    data['dados'].each do |deputy|
      record = Deputy.find_or_create_by(
        name: deputy['nome'],
        deputy_id: deputy['id'],
        legislature_id: deputy['idLegislatura'],
        state: deputy['siglaUf'],
        political_party: deputy['siglaPartido'],
        photo_url: deputy['urlFoto']
      )

      if record.previously_new_record?
        puts "Deputado #{record.name} criado com sucesso"
      else
        puts "Deputado #{record.name} já está cadastrado"
      end
    end
  else
    puts 'Erro ao obter dados da Câmara dos Deputados.'
  end
end
