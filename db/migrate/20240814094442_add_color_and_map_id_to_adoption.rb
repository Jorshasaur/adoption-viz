class AddColorAndMapIdToAdoption < ActiveRecord::Migration[7.2]
  def change
    add_column :adoptions, :color, :string
    add_column :adoptions, :map_id, :integer
  end
end
