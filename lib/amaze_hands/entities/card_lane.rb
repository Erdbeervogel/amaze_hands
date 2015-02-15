class CardLane
  include Lotus::Entity

  attributes :card_number,
             :lane,
             :wait_days

  def wait_days
    @wait_days || 0
  end
end