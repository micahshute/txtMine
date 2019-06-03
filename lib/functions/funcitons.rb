## 
# Contains functions useful for other classes in the gem

class TxtMine::Functions

    ##
    # Destructively insertion sorts in inputted collection. 
    # Good for sorting almost-sorted data. Will be faster 
    # Than ruby's built-in `#sort` in those cases
    def self.insertion_sort!(coll)
        for j in 1...coll.length do
            key = coll[j]
            i = j-1
            while i >= 0 && coll[i] > key
                coll[i+1] = coll[i]
                i -= 1
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

end