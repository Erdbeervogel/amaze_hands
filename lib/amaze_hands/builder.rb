Dir["#{__dir__}/builders/**/*.rb"].each { |f| require f }

class Builder
  include Debuggers::Benchmark
  benchmark_on :build

  attr_reader :ast, :card

  def initialize(ast)
    @ast  = ast
    @card = Card.new
  end

  def build
    Builders::Foundation.new(card).build_with(ast.slice(:card_number, :card_type, :title))
    Builders::CardActions.new(card).build_with(ast[:actions])

    CardRepository.create(card)
  end
end
