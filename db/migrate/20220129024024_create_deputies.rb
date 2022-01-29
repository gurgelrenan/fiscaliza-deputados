class CreateDeputies < ActiveRecord::Migration[7.0]
  def change
    create_table :deputies do |t|
      # Comments are related to the oficial names in the CSV file and API docs from 'camara dos deputados'
      t.string :name # txNomeParlamentar/nome
      t.string :email # -/email
      t.string :cpf # -/cpf
      t.integer :deputy_id # ideCadastro/id
      t.integer :legislature_id # codLegislatura/idLegislatura
      t.string :state, limit: 2 # sgUF/siglaUf
      t.string :political_party # sgPartido/siglaPartido
      t.string :photo_url # -/urlFoto
      t.timestamps
    end
  end
end
