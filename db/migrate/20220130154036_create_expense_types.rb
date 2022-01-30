class CreateExpenseTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :expense_types do |t|
      # Comments are related to the oficial names in the CSV file and API docs from 'camara dos deputados'
      t.integer :expense_type_id # numSubCota/-
      t.string :description # txtDescricao/tipoDespesa

      t.timestamps
    end
  end
end
