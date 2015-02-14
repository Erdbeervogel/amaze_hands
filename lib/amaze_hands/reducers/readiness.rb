require_relative 'base'

module Reducers
  class Readiness < Base
    private

    def tag_card_action(card_action)
      card_action.description.key?(:ready) && card_action.description[:ready] == true
    end
  end
end