require 'csv'

desc "Imports the Adoption data CSV"
task :import_adoptions, [:filename] => :environment do
    CSV.foreach('adoptions.csv', :headers => true) do |row|
        Adoption.create!(
            :year => row["Fiscal Year"],
            :county => row["County"],
            :number => row["Number of Consummated Adoptions"]
        )
    end
end