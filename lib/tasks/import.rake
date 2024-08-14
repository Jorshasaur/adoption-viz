require 'csv'
require 'color_math'
require 'json'

data_folder = './db/data'

class ColorMath
    # Define a method to interpolate between two colors
    def mix_with(other_color, weight)
        red, green, blue = self.to_rgb
        other_red, other_green, other_blue = other_color.to_rgb
        r = (red + (other_red - red) * weight).round
        g = (green + (other_green - green) * weight).round
        b = (blue + (other_blue - blue) * weight).round
        ColorMath.new(r, g, b)
    end
end

### Cleaning up the data in these steps:
# 1. `rake clean_adoptions` Make sure every county is represented in the data
# 2. `rake merge_ids` The map needs specific IDs for each county
# 3. `rake colorize_adoptions` Calculate a color for each county based on the number of adoptions
# 4. `rake import_adoptions` Import the cleaned and colorized data into the database

desc "Imports the Adoption data CSV"
task :import_adoptions, [:filename] => :environment do
    file_path = "#{data_folder}/adoptions.csv"
    CSV.foreach(file_path, :headers => true) do |row|
        Adoption.create!(
            :year => row["Fiscal Year"],
            :county => row["County"],
            :count => row["Number of Consummated Adoptions"],
            :color => row["Color"],
            :map_id => row["Map ID"]
        )
    end
end

desc "Clean the Adoption data so every county is always represented"
task :clean_adoptions, [:filename] => :environment do

    # Load the JSON file to get the list of all counties
    json_file_path = "#{data_folder}/map_ids.json"  
    json_data = JSON.parse(File.read(json_file_path))

    # Load the CSV file with the original adoption data
    csv_file_path = "#{data_folder}/adoptions_input.csv"  
    adoptions_data = CSV.read(csv_file_path, headers: true)

    # Get a list of all counties from the JSON file
    all_counties = json_data.values.map { |value| value['name'] }

    # Group data by 'Fiscal Year' and 'County' and sum the 'Number of Consummated Adoptions'
    grouped_data = adoptions_data.group_by { |row| [row['Fiscal Year'], row['County']] }
    summed_data = grouped_data.map do |key, rows|
        total_adoptions = rows.map { |row| row['Number of Consummated Adoptions'].to_i }.sum
        [key[0], key[1], total_adoptions]
    end

    # Fill in missing counties with 0 adoptions for each fiscal year
    fiscal_years = adoptions_data.map { |row| row['Fiscal Year'] }.uniq
    complete_data = []

    fiscal_years.each do |year|
        all_counties.each do |county|
            existing_entry = summed_data.find { |row| row[0] == year && row[1] == county }
            if existing_entry
                complete_data << existing_entry
            else
                complete_data << [year, county, 0]
            end
        end
    end

    # Save the updated data to a new CSV file
    output_file_path = "#{data_folder}/adoptions_complete.csv"  
    CSV.open(output_file_path, 'wb') do |csv|
    csv << ['Fiscal Year', 'County', 'Number of Consummated Adoptions']
    complete_data.each { |row| csv << row }
    end

    puts "File saved successfully as: #{output_file_path}"

end

desc "Merges the IDs needed for the Map Component"
task :merge_ids, [:filename] => :environment do
    # Load the JSON file
    json_file_path = "#{data_folder}/map_ids.json"  
    json_data = JSON.parse(File.read(json_file_path))

    # Load the CSV file
    csv_file_path = "#{data_folder}/adoptions_complete.csv"  
    adoptions_data = CSV.read(csv_file_path, headers: true)

    # Create a mapping from county name to the JSON key
    county_to_key = {}
        json_data.each do |key, value|
        county_to_key[value['name']] = key
    end

    # Add a new column 'Map ID' to the adoptions data by matching the county name
    adoptions_data.each do |row|
        row['Map ID'] = county_to_key[row['County']]
    end

    # Save the updated data to a new CSV file
    output_file_path = "#{data_folder}/adoptions_with_map_id.csv"
    CSV.open(output_file_path, 'wb') do |csv|
        csv << adoptions_data.headers
        adoptions_data.each do |row|
            csv << row
        end
    end

    puts "File saved successfully as: #{output_file_path}"
end

desc "Summarize and colorize the Adoption data"
task :colorize_adoptions, [:filename] => :environment do
    # Load the CSV file
    file_path = "#{data_folder}/adoptions_with_map_id.csv"
    data = CSV.read(file_path, headers: true)

    # Group data by 'Fiscal Year' and 'County' and sum the 'Number of Consummated Adoptions'
    grouped_data = data.group_by { |row| [row['Fiscal Year'], row['County']] }
    summed_data = grouped_data.map do |key, rows|
        total_adoptions = rows.map { |row| row['Number of Consummated Adoptions'].to_i }.sum
        map_id = rows.first['Map ID']
        [key[0], key[1], total_adoptions, map_id]
    end

    # Find the min and max adoption numbers
    min_adoptions = summed_data.map { |_, _, adoptions| adoptions }.min
    max_adoptions = summed_data.map { |_, _, adoptions| adoptions }.max

  # Function to normalize a value with enhanced contrast
  def normalize(value, min, max)
    # Apply a logarithmic scale for more contrast on low numbers
    log_min = Math.log(min + 1)
    log_max = Math.log(max + 1)
    log_value = Math.log(value + 1)

    (log_value - log_min) / (log_max - log_min)
  end

    # Function to get color shade based on adoption count
    def get_color(adoptions, min_adoptions, max_adoptions, map_id)
        normalized_value = normalize(adoptions, min_adoptions, max_adoptions)
  
        # Adjust the starting color to a light blue (#e0f7fa) instead of white
        base_color = ColorMath.new(224, 247, 250) # Light blue RGB (e0f7fa)
        max_color = ColorMath.new(0, 0, 255)      # Dark blue RGB (0000ff)
      
        # Interpolate between base_color and max_color based on normalized_value
        interpolated_color = base_color.mix_with(max_color, normalized_value)
        interpolated_color.to_hex
    end

    # Add color mapping based on the number of adoptions
    colored_data = summed_data.map do |year, county, adoptions, map_id|
        color = get_color(adoptions, min_adoptions, max_adoptions, map_id)
        [year, county, adoptions, color, map_id]
    end

    # Save the updated data to a new CSV file
    output_file_path = "#{data_folder}/adoptions.csv"
    CSV.open(output_file_path, 'wb') do |csv|
        csv << ['Fiscal Year', 'County', 'Number of Consummated Adoptions', 'Color', 'Map ID']
        colored_data.each { |row| csv << row }
    end

    puts "File saved successfully as: #{output_file_path}"
end