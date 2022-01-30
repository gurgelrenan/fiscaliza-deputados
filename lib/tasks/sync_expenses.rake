task :sync_expenses => :environment do
  years = [2019, 2020, 2021, 2022]

  years.each do |year|
    populate_data(year)
  end
end

def populate_data(year)
  puts "Populating data for #{year}..."

  Deputy.all.each do |deputy|
    first_url = "https://dadosabertos.camara.leg.br/api/v2/deputados/#{deputy.deputy_id}/despesas?idLegislatura=#{deputy.legislature_id}&ano=#{year}&ordem=asc&ordenarPor=mes&itens=100"

    response = Faraday.get(first_url)
    
    if response.status == 200
      puts "Starting sync for deputy #{deputy.name}..."
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
      puts "Finished #{deputy.name}"
    else
      puts 'Erro ao obter dados da Câmara dos Deputados.'
    end    
  end
end


def save_expense(data, deputy)
  data['dados'].each do |row|
    provider = Provider.find_or_create_by(
      name: row['nomeFornecedor'], 
      cpf_cnpj: row['cnpjCpfFornecedor']
    )
    expense_type = ExpenseType.find_or_create_by(
      description: row['tipoDespesa']
    )
    Expense.find_or_create_by!(
      deputy_id: deputy.id,
      expense_type_id: expense_type.id,
      provider_id: provider.id,
      year: row['ano'],
      month: row['mes'],
      document_code: row['codDocumento'],
      document_number: row['numDocumento'],
      document_type: row['tipoDocumento'],
      document_type_id: row['codTipoDocumento'],
      date: row['dataDocumento'],
      value: row['valorDocumento'],
      net_value: row['valorLiquido'],
      gloss_value: row['valorGlosa'],
      document_url: row['urlDocumento'],
      refund_number: row['numRessarcimento'],
      batch_code: row['codLote'],
      tranche: row['parcela']
    )
  end
end
