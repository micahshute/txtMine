require_relative '../spec_helper'
RSpec.describe TxtMine::Tolkenizer do
    
  let(:sample_text) do 
    %q{Simply put, the Fourier Transform allows humans or machines to see time domain signals in the frequency domain. Common applications are data visualization in oscilloscopes and function generators, radar, sonar, spectral analysis, digital communication signal processing, and instrument monitoring.
      There is also a broad range of uses for the Fourier Transform beyond visualization or even an end game of frequency analysis. Linear Time Invariant (LTI) systems and signals respond to each other through convolution, which can be a mathematically impractical operation to evaluate. These system outputs can be modeled accurately by simply multiplying their Fourier Transforms together and then converting them back to the time domain, given that we avoid aliasing when doing so.
      Lastly, a lot of data compression uses algorithms similar to the Fast Fourier Transform. For example, JPEGs use the Discrete Cosine Transform which is very similar to the Discrete Fourier Transform.
      }
  end

  it "keeps track of document ids and returns a unique one for each tolkenized document" do
    expect(false).to eq(true)
  end

  describe ".create_and_process" do

    it "can instantiate a tolkenizer and process the text all in one step" do
      expect(false).to eq(true)
    end
    
  end 

  describe ".get_next_doc_id" do

    it "returns the correct document id regardless of whether you are tracking all docs or just the next one" do
      expect(false).to eq(true)
    end
    
  end

  describe "#delimit_text" do

    it "can delmit text with different delimeters" do
      default_tolkenizer = TxtMine::Tolkenizer.new(text: sample_text)
      default_tolkenizer.delimit_text

      whitespace_tolkenizer = TxtMine::Tolkenizer.new(text: sample_text, delimeter: TxtMine::Strategy::WhitespaceDelimeter)
      whitespace_tolkenizer.delimit_text

      pdelim = TxtMine::Strategy::PunctuationDelimeter
      wdelim = TxtMine::Strategy::WhitespaceDelimeter
      expect(pdelim.delimit(sample_text)).to eq(default_tolkenizer.text)
      expect(wdelim.delimit(sample_text)).to eq(whitespace_tolkenizer.text)
    end
  end

  describe "#case_text" do
    it "dowcases text by default but can choose not to" do
      default_tolkenizer = TxtMine::Tolkenizer.new(text: sample_text)
      default_tolkenizer.delimit_text
      default_tolkenizer.case_text
      expect(default_tolkenizer.text.map(&:downcase)).to eq(default_tolkenizer.text)

      no_dc_tolkenizer = TxtMine::Tolkenizer.new(text: sample_text, downcase: false)
      no_dc_tolkenizer.delimit_text
      no_dc_tolkenizer.case_text
      expect(no_dc_tolkenizer.text.map(&:downcase)).not_to eq(no_dc_tolkenizer.text)
    end
  end

  describe "#filter_text" do
    it "can filter Stop Words from text given an array of stop words (defaults to standard stop words)" do
      words = STOP_WORDS.join(" ") + "    " + STOP_WORDS.join(" ")
      t = TxtMine::Tolkenizer.new(text: words)
      t.delimit_text
      t.case_text

      expect(t.text.length).not_to eq(0)
      expect(t.text.length).to eq(STOP_WORDS.length * 2)

      t.filter_text
      
      expect(t.text.length).to eq(0)

    end
  end


  describe "#process" do
    it "can delimit, downcase, and filter text via the #process method." do
      expect(false).to eq(true)
    end

    it "returns a TolkenizedDocument instance" do
      expect(false).to eq(true)
    end
  end


  
end