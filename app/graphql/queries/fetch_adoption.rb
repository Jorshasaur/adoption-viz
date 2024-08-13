module Queries
    class FetchAdoption < Queries::BaseQuery
        type Types::AdoptionType, null: false
        argument :id, ID, required: true

        def resolve(id:) 
            Adoption.find(:id)
        end
    end
end