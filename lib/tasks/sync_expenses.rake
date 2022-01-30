task :sync_expenses => :environment do
  Deputy.all.each do |deputy|
    first_url = "https://dadosabertos.camara.leg.br/api/v2/deputados/#{deputy.deputy_id}/despesas?idLegislatura=#{deputy.legislature_id}&ordem=DESC&ordenarPor=ano&itens=100"

    response = Faraday.get(first_url)
    
    if response.status == 200
      data = JSON.parse(response.body)

      save_expense(data, deputy)
  
      next_url = data['links'].select { |link| link['rel'] == 'next' }

      if !next_url.empty?
        new_url = next_url.first['href']

        while new_url.present?
          response = Faraday.get(new_url)
          data = JSON.parse(response.body)
  
          save_expense(data, deputy)
  
          next_url = data['links'].select { |link| link['rel'] == 'next' }
          if next_url.present?
            new_url = next_url.first['href']
          else
            new_url = nil
          end
        end
      end
    else
      puts 'Erro ao obter dados da Câmara dos Deputados.'
    end    
  end
end

def save_expense(data, deputy)
  
end
