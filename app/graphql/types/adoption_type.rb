# frozen_string_literal: true

module Types
  class AdoptionType < Types::BaseObject
    field :id, ID, null: false
    field :year, String
    field :relative, Boolean
    field :number, Integer
    field :county, String
    field :agency, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
