## 
# Contains functions useful for other classes in the gem

class TxtMine::Functions

	##
	# Destructively insertion sorts an inputted collection. 
	# Good for sorting almost-sorted data. Will be faster 
	# Than ruby's built-in `#sort` in those cases
	# If a block is given, two parameters |a,b| are handed to you.
	# Return true if a should be to the right of key when ordering
	# your sorted array from left to right.
	# IE for a sorted array, if a is 5 and b is 2, 
	# return a > b which is 5 > 2 (ie true) 
	def self.insertion_sort!(coll)
		for j in 1...coll.length do
			key = coll[j]
			i = j-1
			if block_given?
				while i >= 0 && yield(coll[i], key) # Return true when col[i] > key
					coll[i+1] = coll[i]
					i -= 1
				end
			else
				while i >= 0 && coll[i] > key
						coll[i+1] = coll[i]
						i -= 1
				end
			end
			coll[i+1] = key
		end
		return coll
	end


	##
	# Return a hash which is a frequency count of the elements of the passed in array
	# return hash will have form {element => number_of_times_in_array}
	#ie:
	## freq_count([1,2,2,1,3]) # => {1 => 2, 2 => 2, 3 => 1}
	def self.freq_count(arr)
		arr.reduce({}){ |hist, e| hist[e] ||= 0; hist[e] += 1; hist}
	end


	##
	# Allow a custom merge operation on two objects
	## rgen = Random.new
	## coll1 = []
	## coll2 = []
	## 10.times { coll1 << OpenStruct.new(num: rgen.rand) }
	## 10.times { coll2 << OpenStruct.new(num: rgen.rand) }
	## coll1.sort!{ |a,b| a.num <=> b.num } # => [0.03487909057248051, 0.09917103700673668, 0.268788128873637, 0.4709475457157205, 0.6440975993991198, 0.6787783519600992, 0.8306938448844432, 0.8400887612063969, 0.9061023061228871, 0.9711913973349926] 
	## coll2.sort!{ |a,b| a.num <=> b.num }# => [0.0027464589764794045, 0.1437025829513453, 0.1551882024338438, 0.3577303682846722, 0.39922026397604227, 0.6064910551493227, 0.7298715585007346, 0.7556301972235012, 0.7557489060549826, 0.8480248342178041] 
	## res = TxtMine::Functions.merge(coll1, coll2) do |a, b|
	##   a.num < b.num
	## end
	## res # => [0.0027464589764794045, 0.03487909057248051, 0.09917103700673668, 0.1437025829513453, 0.1551882024338438, 0.268788128873637, 0.3577303682846722, 0.39922026397604227, 0.4709475457157205, 0.6064910551493227, 0.6440975993991198, 0.6787783519600992, 0.7298715585007346, 0.7556301972235012, 0.7557489060549826, 0.8306938448844432, 0.8400887612063969, 0.8480248342178041, 0.9061023061228871, 0.9711913973349926] 
	def self.merge(left, right)
		merged_arr = []
		i, j = 0, 0
		while i < left.length && j < right.length
			#puts "Comparing lhs #{left[i]} to rhs #{right[j]}"
			if yield(left[i], right[j]) # For yield(a,b) have a < b be true to have a go first
				# See above example
				#puts "Adding lhs #{left[i]}"
				merged_arr << left[i]
				i += 1
			else
				#puts "Adding rhs #{right[j]}"
				merged_arr << right[j]
				j += 1
			end
		end
		merged_arr.concat right[j, right.length] if i == left.length
		merged_arr.concat left[i, left.length] if j == right.length
		#puts merged_arr.to_s
		merged_arr
	end


	##
	# Find the mean of an input array fo numbers
	def self.mean(col)
		col.reduce(&:+) / col.length.to_f
	end

end