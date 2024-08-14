# frozen_string_literal: true

module Types
  class AdoptionType < Types::BaseObject
    field :id, ID, null: false
    field :year, String
    field :count, Integer
    field :county, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :color, String
    field :map_id, Integer
  end
end
