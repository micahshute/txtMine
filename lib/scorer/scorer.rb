class TxtMine::Scorer

	def initialize(indexer)
		@indexer = indexer
	end

	def df(word)
		return @indexer.lexicon[word][:docs].length
	end

	def total_docs
		return @indexer.docs.length
	end

	def avg_doc_len
		TxtMine::Functions.mean(@indexer.docs.map(&:doc_len))
	end

	def bm25_doc_ranking(query: , max: 100, b: 0.6, k: 1.2, no_idf: false)
		winners = []
		query = TxtMine::Strategy::PunctuationDelimeter.delimit(query)
		@indexer.docs.each do |doc|
			score = doc_bm25(query: query, doc: doc, b: b, k: k, no_idf: no_idf)
			if winners.length == 0 || winners.last[:score] < score
				winners << {doc: doc, score: score}
				TxtMine::Functions.insertion_sort!(winners){ |a, b| a[:score] < b[:score] }
				winners = winners.take(max)
			end
		end
		return winners
	end

	def doc_bm25(query: , doc: , b: 0.6, k: 1.2, no_idf: false)
		query.map do |word|
			self.bm25(word: word, doc: doc, b: b, k: k, no_idf: no_idf)
		end.reduce(&:+)
	end

	def bm25(word: , doc: , b: 0.6, k: 1.2, no_idf: false)
		return 0 if doc.index[word].nil?
		tf = doc.index[word]
		idf_term = no_idf ? 1 : Math::log((self.total_docs + 1) / df(word).to_f) 
		freq_term = (k + 1) * tf 
		doclen_term = tf + (k * (1 - b + b * (doc.doc_len.to_f / self.avg_doc_len)))
		return (freq_term.to_f / doclen_term) * idf_term
	end

end