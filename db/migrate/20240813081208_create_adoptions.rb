class CreateAdoptions < ActiveRecord::Migration[7.2]
  def change
    create_table :adoptions do |t|
      t.string :year
      t.boolean :relative
      t.integer :number
      t.string :county
      t.string :agency
      t.timestamps
    end  
  end
end
