class TxtMine::Strategy::WhitespaceDelimeter

	def self.delimit(text)
		return text.split(/\s+/).map(&:strip)
	end

end