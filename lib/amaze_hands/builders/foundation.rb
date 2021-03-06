require_relative 'base'

module Builders
  class Foundation < Base
    def build_with(attributes)
      card.number = attributes[:card_number]
      card.type   = attributes[:card_type]
      card.title  = attributes[:title]
    end
  end
end
