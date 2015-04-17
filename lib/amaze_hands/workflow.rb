Dir["#{__dir__}/{strategies}/**/*.rb"].each { |f| require f }

require_relative 'builder'
require_relative 'reducer'
require_relative 'analyser'
require_relative 'producer'

class Workflow
  include Debuggers::Benchmark
  benchmark_on :initialize, :metrics, :clean_up_db

  attr_reader :strategy

  def initialize(strategy:, source:)
    @strategy = strategy

    clean_up_db

    if source.is_a?(Array)
      perform_on_dir(source)
    else
      perform_on_file(source)
    end
  end

  def metrics(measure_every: 2.weeks, start_date: DateTime.parse('01-01-2015'))
    Producer.new(
      measure_every: measure_every,
      start_date:    start_date
    ).metrics
  end

  private

  def clean_up_db
    CardRepository.clear
    CardActionRepository.clear
    CardLaneRepository.clear
  end

  def perform_on_dir(files)
    files.each do |file|
      perform_on(File.new(file).read)
    end
  end

  def perform_on_file(file)
    File.new(file).each do |line|
      perform_on(line)
    end
  end

  def perform_on(content)
    binding.pry
    ast        = strategy::Parser.new.parse(content)
    common_ast = strategy::Transformer.new.apply(ast)
    card       = Builder.new(common_ast).build

    Reducer.new(card, lanes: strategy::Lanes).tag
    Analyser.new(card).analyse
  end
end
