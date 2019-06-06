require_relative '../spec_helper'
RSpec.describe TxtMine::Tolkenizer do
    
  let(:sample_text) do 
    %q{Simply put, the Fourier Transform allows humans or machines to see time domain signals in the frequency domain. Common applications are data visualization in oscilloscopes and function generators, radar, sonar, spectral analysis, digital communication signal processing, and instrument monitoring.
      There is also a broad range of uses for the Fourier Transform beyond visualization or even an end game of frequency analysis. Linear Time Invariant (LTI) systems and signals respond to each other through convolution, which can be a mathematically impractical operation to evaluate. These system outputs can be modeled accurately by simply multiplying their Fourier Transforms together and then converting them back to the time domain, given that we avoid aliasing when doing so.
      Lastly, a lot of data compression uses algorithms similar to the Fast Fourier Transform. For example, JPEGs use the Discrete Cosine Transform which is very similar to the Discrete Fourier Transform.
      }
  end

  it "keeps track of document ids and returns a unique one for each tolkenized document" do

    tarr = Array.new(10, sample_text)
    doc_ids = tarr.map{ |t| TxtMine::Tolkenizer.create_and_process(text: t).doc_id }
    expect(doc_ids).to eq((1..10).to_a)
    
  end

  describe ".create_and_process" do

    it "can instantiate a tolkenizer and process the text all in one step" do
      t1 = TxtMine::Tolkenizer.new(text: sample_text)
      tdoc1 = t1.process
      tdoc2 = TxtMine::Tolkenizer.create_and_process(text: sample_text)
      expect(tdoc1.index).to eq(tdoc2.index)
      expect(tdoc1.doc_id).to eq(tdoc2.doc_id - 1)
    end
    
  end 

  describe ".get_next_doc_id" do

    it "returns the correct document id regardless of whether you are tracking all docs or just the next one" do
      TxtMine::Tolkenizer.next_doc_id = 1
      TxtMine::Tolkenizer.populate_doc_ids([])

      5.times do 
        t = TxtMine::Tolkenizer.create_and_process(text: sample_text)
      end

      expect(TxtMine::Tolkenizer.class_variable_get("@@next_doc_id")).to eq(6)
      expect(TxtMine::Tolkenizer.class_variable_get("@@doc_ids")).to eq([])

      TxtMine::Tolkenizer.next_doc_id = 1
      TxtMine::Tolkenizer.populate_doc_ids((1..5).to_a)

      5.times do
        t = TxtMine::Tolkenizer.create_and_process(text: sample_text)
      end
      expect(TxtMine::Tolkenizer.class_variable_get("@@next_doc_id")).to eq(11)
      expect(TxtMine::Tolkenizer.class_variable_get("@@doc_ids")).to eq((1..10).to_a)
      expect(TxtMine::Tolkenizer.get_next_doc_id).to eq(11)
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

    it "will not filter stop words if initialized with no stop words" do 
      words = STOP_WORDS.join(" ")
      t = TxtMine::Tolkenizer.new(text: words, stop_words: nil)
      t.delimit_text
      t.case_text
      t.filter_text
      expect(t.text.length).to eq(STOP_WORDS.length)
    end
  end


  describe "#process" do
    it "can delimit, case, and filter text via the #process method." do
      t = TxtMine::Tolkenizer.new(text: sample_text)
      t.process
      t2 = TxtMine::Tolkenizer.new(text: sample_text)
      t2.delimit_text
      t2.case_text
      t2.filter_text
      expect(t.text).to eq(t2.text)
    end

    it "returns a TolkenizedDocument instance" do
      t = TxtMine::Tolkenizer.new(text: sample_text)
      expect(t.process.class).to be(TxtMine::Tolkenizer::TolkenizedDocument)
    end

    it "returns a frequency hash of the word bag" do
      t = TxtMine::Tolkenizer.new(text: sample_text, stop_words: nil)
      tdoc = t.process
      freq_hash = {}
      for word in TxtMine::Strategy::PunctuationDelimeter.delimit(sample_text).map(&:downcase)
        freq_hash[word] ||= 0
        freq_hash[word] += 1
      end
      expect(tdoc.index).to eq(freq_hash)
    end

  end
  
end