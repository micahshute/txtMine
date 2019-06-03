class TxtMine::Strategy::PunctuationDelimeter

    def self.delimit(text)
        text.split(/[\s\?\,\.\'\"\/:;-]+/).map(&:strip)
    end

end