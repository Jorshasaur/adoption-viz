# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject

    description "The query root of this schema"
    field :adoption, resolver: Resolvers::AdoptionResolver
  end
end
