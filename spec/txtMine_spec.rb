RSpec.describe TxtMine do
  it "has a version number" do
    expect(TxtMine::VERSION).not_to be nil
  end

  it "does something useful" do
    medium_articles = CSV.read("../assets/articles.csv").map(&:last)
    medium_articles.shift
    docs = medium_articles.map.with_index{ |art, i| TxtMine::Tolkenizer.create_and_process(text: art, doc_id: i)}
    indexer = TxtMine::Indexer.new(docs)
    scorer = TxtMine::Scorer.new(indexer)
    binding.pry
  end
end
