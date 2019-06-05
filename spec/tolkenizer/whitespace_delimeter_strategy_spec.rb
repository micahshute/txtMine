require_relative '../spec_helper'
RSpec.describe TxtMine::Strategy::WhitespaceDelimeter do
    
    let(:sample_string) do
        "This is a string,   which shouldn't be deliniated? By anything but white    spaces !!!"
    end


    it "delimits text via punctuation" do
        expect(TxtMine::Strategy::WhitespaceDelimeter.delimit(sample_string)).to eq(["This", "is", "a", "string,", "which", "shouldn't", "be", "deliniated?", "By", "anything", "but", "white", "spaces", "!!!"] )
    end

end