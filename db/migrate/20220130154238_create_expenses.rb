class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
    # Comments are related to the oficial names in the CSV file and API docs from 'camara dos deputados'
    t.references :deputy, null: false, foreign_key: true
    t.references :expense_type, null: false, foreign_key: true
    t.references :provider, null: false, foreign_key: true

    t.integer :year # numAno/ano
    t.integer :month # numMes/mes
    t.integer :document_code # ideDocumento/codDocumento
    t.string :document_number # txtNumero/numDocumento
    t.string :document_type # -/tipoDocumento
    t.integer :document_type_id # indTipoDocumento/codTipoDocumento
    t.date :date # datEmissao/dataDocumento
    t.decimal :value, precision: 10, scale: 2 # vlrDocumento/valorDocumento
    t.decimal :net_value, precision: 10, scale: 2 # vlrLiquido/valorLiquido
    t.decimal :gloss_value, precision: 10, scale: 2 # vlrGlosa/valorGlosa
    t.string :document_url # -/urlDocumento
    t.string :refund_number # numRessarcimento/numRessarcimento
    t.integer :batch_code # numLote/codLote
    t.integer :tranche # numParcela/parcela

    t.timestamps
    end
  end
end
