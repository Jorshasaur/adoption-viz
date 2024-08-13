# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :adoption, [Types::AdoptionType], null: false, description: "Fetch the adoption data by year" do
      argument :year, String, required: true
    end
    def adoption(year:)
      Adoption.where(year: year)
    end
  end
end
