class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      # Comments are related to the oficial names in the CSV file and API docs from 'camara dos deputados'
      t.string :name # txtFornecedor/nomeFornecedor
      t.string :cpf_cnpj # txtCNPJCPF/cnpjCpfFornecedor

      t.timestamps
    end
  end
end
