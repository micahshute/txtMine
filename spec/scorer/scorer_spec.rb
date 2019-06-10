require_relative '../spec_helper'
RSpec.describe TxtMine::Tolkenizer do

	let(:text1) do 
		%q{I started contributing to open source and putting all my tiny side projects on GitHub a while ago. Back then I didn’t know about the README part. Time passed and I started following some kickass developers. No doubt they all had amazing projects but the one most common thing was, all their projects had awesome README and that’s how I came to know about the importance of a good README.}
	end

	let(:text2) do
		%q{It describes the asymptotic nature of a system as the input grows. Usually, we are describing runtime of an algorithm, but it can also be used to describe space complexity or even systems outside the realm of computer science. Here I will assume it describes runtime of an algorithm unless stated otherwise. Asymptotic analysis means that you focus on how the runtime of the algorithm grows as the input grows and approaches infinity. The input is usually denoted as n. As our datasets get larger, it is the growth function which will be the dominating factor of runtime. For example, O(n) suggests that the runtime changes linearly with the input n. O(n^2 ) suggests that the runtime changes proportionally to the size of the input squared. With large datasets, this is usually enough information to tell you which one will be faster.}
	end


	describe " #bm25" do
		it "scores documents based off of query word relevance" do
			t1 = TxtMine::Tolkenizer.create_and_process(text: text1)
			t2 = TxtMine::Tolkenizer.create_and_process(text: text2)
			indexer = TxtMine::Indexer.new([t1, t2])
			scorer = TxtMine::Scorer.new(indexer)
			expect(true).to eq(false)
			# binding.pry
		end
	end
end