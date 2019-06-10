##
# Class in charge of indexing all of the tolkenized documents
class TxtMine::Indexer

	attr_reader :lexicon

	##
	# Initialize with an array of tolkenized docs
	# == 
	# tolkenized_docs:: Array
	def initialize(tolkenized_docs)
		@docs = tolkenized_docs
		@lexicon = {}
		@docs.each { |doc| self.add_to_lexicon(doc) }
	end

	##
	# Adds a tolkenized doucment to @docs
	# Sorts the @docs, and adds the doc to the lexicon
	# == args
	# doc:: TxtMine::Tolkenizer::TolkenizedDocument
	def add_doc(doc)
		@docs << doc
		@docs.sort!{ |a,b| a <=> b }
		self.add_to_lexicon(doc)
	end

	##
	# Frozen reader for @docs
	def docs
		return @docs.freeze
	end

	## 
	# Adds a tolkenized doc to the lexicon
	# The lexicon is a hash with a first-level key set of words
	# whose values are a hash with keys count: Integer, and docs: Array[TxtMine::Tolkenizer::TolkenizedDocuments]
	# == args
	# doc:: TxtMine::Tolkenizer::TolkenizedDcouments
	def add_to_lexicon(doc)
		doc.index.each do |word, freq|
			@lexicon[word] ||= {count: 0, docs: []}
			@lexicon[word][:count] += freq
			@lexicon[word][:docs] << doc
		end
	end

end