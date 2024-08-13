class RemoveAgencyAndRelativeFromAdoptions < ActiveRecord::Migration[7.2]
  def change
    remove_column :adoptions, :agency, :string
    remove_column :adoptions, :relative, :boolean
  end
end
