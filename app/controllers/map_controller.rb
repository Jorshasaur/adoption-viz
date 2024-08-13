# frozen_string_literal: true

class MapController < ApplicationController
  layout "map"

  def index
    @map_props = { name: "Stranger" }
  end
end
