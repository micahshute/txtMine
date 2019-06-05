require_relative '../spec_helper'
RSpec.describe TxtMine::Strategy::PunctuationDelimeter do
    

  let(:sample_string) do
    "This is a string,   which shouldn't not  be deliniated? By (anything) but white    spaces so it's like punctua!ion and stuff? !!!"
  end

  it "delimits text via punctuation" do
    expect(TxtMine::Strategy::PunctuationDelimeter.delimit(sample_string)).to eq(["This", "is", "a", "string", "which", "shouldn", "t", "not", "be", "deliniated", "By", "anything", "but", "white", "spaces", "so", "it", "s", "like", "punctua", "ion", "and", "stuff"])
  end

end