## Tolkenizer determines how to represent a document
# It requires a text input, a document id (can be given automatically), 
# TODO: Add threads
class TxtMine::Tolkenizer

  ## MARK: Class Variables

  ## 
  # Allows either @@doc_ids array or @@next_id to be used to keep track of document id number
  @@doc_ids = []
  @@next_doc_id = 1
  ## MARK: Class Methods

  ##
  # Allows setting the existing document ids (integers)
  # sorts the inputted array of ids
  #TODO: Multithread sort operation
  def self.populate_doc_ids(ids)
      @@doc_ids = ids.sort
  end

  ##
  # Returns a frozen version of the @@doc_ids array (array of integers)
  def self.doc_ids
      return @@doc_ids.freeze
  end

  ##
  # Accepts an integer which will be the id of the newest document
  # Adds a document id to the class variable @@doc_ids
  # and then insertion sorts the @@doc_ids array
  def self.add_doc_id(id)
      @@doc_ids << id
      TxtMine::Functions.insertion_sort!(@@doc_ids)
  end


  ##
  # Setter for @@next_doc_id
  def self.next_doc_id=(next_id)
    @@next_doc_id = next_id
  end 

  ##
  #
  # One optional argument of use_next_id. The argument defaults to `true`, in which case it does not
  # use the @@doc_ids to get the next doc_id but instead uses the @@next_id
  # If the argument is `false` it will
  # return the next document ID number 
  # as just one higher than the last element in the array (assuming the array is sorted)
  def self.get_next_doc_id(use_next_id = true)
    if !use_next_id || @@doc_ids.length > 0
      if @@doc_ids.length == 0 
        @@doc_ids << 1
        return 1
      end
      @@doc_ids << @@doc_ids.last + 1
      return @@doc_ids.last
    else
      id = @@next_doc_id
      @@next_doc_id += 1
      return id
    end
  end

  ##
  # Allows to create and process a document in one step. Will not return the tolkenizer instnace but instead the return of `process`
  def self.create_and_process(text: ,delimeter: TxtMine::Strategy::PunctuationDelimeter, stop_words: STOP_WORDS, downcase: true, doc_id: self.get_next_doc_id)
    tolkenizer = self.new(text: text, delimeter: delimeter, stop_words: stop_words, downcase: downcase, doc_id: doc_id)
    return tolkenizer.process
  end


  attr_reader :text, :delimeter, :stop_words, :downcase, :doc_id

  ## MARK: Instance Variables

  ##
  # == A tolkenizer instance in initialized with 
  # text:: String
  # doc_id:: Integer
  # delimeter:: DelimeterStrategy (must have #delimit which accepts a string, outputs an array of strings)
  # stop_words:: array of strings, downcase: boolean
  def initialize(text: ,delimeter: TxtMine::Strategy::PunctuationDelimeter, stop_words: STOP_WORDS, downcase: true, doc_id: self.class.get_next_doc_id)
    @text, @delimeter, @stop_words, @downcase, @doc_id = text, delimeter, stop_words, downcase, doc_id
    @stop_words ||= []
    @delimited, @cased, @filtered = false, false, false
    self.class.next_doc_id = doc_id + 1 if doc_id != @@next_doc_id - 1

  end

  ##
  # Processes @text via delimiting it, removing stop words, and downcasing it based off of the value of @downcase
  def process
    self.delimit_text unless @delimited
    self.case_text unless @cased
    self.filter_text unless @filtered
    return TolkenizedDocument.new(TxtMine::Functions.freq_count(@text), @doc_id)
  end

  ##
  # Requires no input argument, delimits the @text 
  def delimit_text
    @delimited = true
    @text = delimeter.delimit(@text)
  end

  ##
  # Downcase text if @downcase is true, otherwise do nothing
  def case_text
    @cased = true
    if @text.is_a?(String)
      @text = @downcase ? @text.downcase : @text
    elsif @text.is_a?(Array)
      @text = @downcase ? @text.map(&:downcase) : @text
    else
      raise Error.new("@text must be a string or an Array")
    end
  end

  # remove stopwords from text. Will work if @text is an array or a string
  def filter_text
    raise Error.new('Text must be delimted before it is filtered') unless @text.is_a?(Array)
    @filtered = true
    @text = @text.select{ |word| !@stop_words.include?(word) }
  end


  ## 
  # The return object of the #process method will be an instnace of TolkenizedDocument
  class TolkenizedDocument

    attr_reader :index, :doc_id, :doc_len

    def initialize(index, doc_id)
      @index, @doc_id = index, doc_id
      @doc_len = index.reduce(0){ |memo, (word, freq)| memo + freq}
    end

  end

end