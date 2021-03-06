class CardActionRepository
  include Lotus::Repository

  def self.all_by_card(card)
    query { where(card_number: card.number) }
  end

  def self.analysable_by_card(card)
    all_by_card(card).where(analysable: true)
  end
end
