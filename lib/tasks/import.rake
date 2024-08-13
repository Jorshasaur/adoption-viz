require 'csv'

desc "Imports the Adoption data CSV"
task :import_adoptions, [:filename] => :environment do
    CSV.foreach('adoptions.csv', :headers => true) do |row|
        Adoption.create!(
            :year => row["Fiscal Year"],
            :county => row["County"],
            :agency => row["Agency Type"],
            :relative => row["Relative Adoption"],
            :number => row["Number of Consummated Adoptions"]
        )
    end
end