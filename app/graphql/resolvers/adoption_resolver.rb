module Resolvers
    class AdoptionResolver < Resolvers::BaseResolver
        type [Types::AdoptionType], null: false
        description "Fetch the adoption data by year"
        argument :year, String, required: true

        def resolve(year:)
            Adoption.where(year: year)
        end
    end
end