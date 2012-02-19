# CodeEval Discount Offers
#
# Author: Max Dunn
# Email: max@maxdunn.com
# Date: Feb 8, 2012
#
# Strategy: 
# First, create the scores matrix by applying the rules. 
# Notice that since we just need to find the highest scores, we can now treat this as an abstract matrix.
# Notice also, that we can swap rows and columns without changing the result.
# Rearrange the matrix so it is sorted along the main diagonal
#
# Visualization:
#
#  9 x x x x x
#  x 8 x x x x
#  x x 7 x x x
#  x x x 6 x x
#  x x x x 5 x
#
# Note: doesn't need to be square
# To do this, first look for the highest value and put in pos 0,0. Then from the remaining rows and columns, find the next
# highest value and put at position 1,1, etc. This will get us close to the answer.
# Finally, do a bubble sort to see if swapping rows or columns will give a higher diagonal value. Do this by just looking
# at the 4 cells around the diagonal.
# Trick: We don't need to physically sort the matrix each time. Just keep the diagonal positions in @path and use this
# to access the array like it is sorted.

class String
  def letters
    downcase.count('a-z') 
  end
  
  def letters_even?
    letters.even?
  end
  
  def vowels
    downcase.count('aeiouy')
  end
  
  def consonants
    downcase.count('a-z', '^aeiouy')
  end
end

def common_factors(s1, s2)
  l1 = s1.letters
  l2 = s2.letters
  return l1.gcd(l2) > 1
end

def ss_score(pers, prod)
  score = 0.0
  if prod.letters_even?
    score += pers.vowels * 1.5
  else
    score += pers.consonants
  end
  if common_factors(pers, prod)
    score *= 1.5 
  end
  return score
end

class Scores
  def initialize(persons, products)
    @persons = persons
    @products = products
    @scores = {}
    calc_scores(persons, products)
    @path = []
    setup_initial_path
  end

  def calc_scores(persons, products)
    persons.each_with_index do |pers, pers_n|
      products.each_with_index do |prod, prod_n|
        @scores[[pers_n, prod_n]] = ss_score(pers, prod)
      end
    end
  end
  
  # This will find the initial path by looking for the highest score then deleting those rows and cols
  # and then looking for the next highest value, etc. It does a pretty good job of getting the path
  # close to optimum
  def setup_initial_path
    temp_scores = @scores.dup
    
    # Keep going until temp_scores are all gone
    while temp_scores.length > 0
      
      # Find the highest score and pos of all remaining scores
      high_score = -1.0
      pos = []
      temp_scores.each do |key, value| 
        if high_score < value
          high_score = value
          pos = key
        end
      end
      
      # save the pos in the path and delete all corresponding rows and columns
      @path << pos.dup
      temp_scores.delete_if {|key, value| key.first == pos.first || key.last == pos.last}
    end
  end
  
  def sort_matrix
    # repeat until we get the same score, up to a maximum of a hundred times in case there is some resonance
    last_total_score = 0
    0.upto(100) do |times|
      
      # Need to define these up here so they can be used outside the inner loop
      any_switched = false
      
      # Do a matrix bubble sort. This is not very efficient but the initial path setup gets it very close
      # so on all the test data, only one pass is needed anyways
      #
      # We are comparing this path pos with with next pos, so only go up to second to last one
      0.upto(@path.length - 2) do |n| 

        # Here, we are looking at a 2x2 matrix comprised of this path pos and the next pos and their crosses
        # We sum the two diagonals to see if we switched the row or column (or both), if we get a higher total score        
        this_row = @path[n].first
        this_col = @path[n].last
        next_row = @path[n + 1].first
        next_col = @path[n + 1].last 
        diag_sum = @scores[[this_row,this_col]] + @scores[[next_row,next_col]]
        anti_diag_sum = @scores[[this_row,next_col]] + @scores[[next_row,this_col]]
        diag_sum_larger = diag_sum > anti_diag_sum
  
        # Switch cols if diag_sum is larger but opposite val is greater, 
        # or if anti_diag sum is larger and next col value is greater than next row
        # Use >= in second line in case both values are the same, we still need to switch 
        switch_cols = (diag_sum_larger && (@scores[[next_row,next_col]] > @scores[[this_row,this_col]])) ||
          (!diag_sum_larger && (@scores[[this_row,next_col]] >= @scores[[next_row,this_col]]))
          
        # Switch cols if diag_sum is larger but opposite val is greater (same as above), 
        # or if anti_diag sum is larger and next row value is greater than next col value
        # Use > in second line because case both values are the same, we already switched 
        switch_rows = (diag_sum_larger && (@scores[[next_row,next_col]] > @scores[[this_row,this_col]])) ||
          (!diag_sum_larger && (@scores[[next_row,this_col]] > @scores[[this_row,next_col]]))
        
        if switch_cols
          any_switched = true
          @path[n][1] = next_col
          @path[n + 1][1] =  this_col
        end
        
        if switch_rows
          any_switched = true
          @path[n][0] = next_row
          @path[n + 1][0] =  this_row
        end
      end
      
      # Check to see if we are getting higher values, if not, then quit
      if last_total_score == total_score
        break
      else
        last_total_score = total_score
      end
    end
  end

  def print_matrix
    (0..(@persons.length - 1)).each do |pers_n|
      (0..(@products.length - 1)).each do |prod_n|
        s = sprintf ("%.2f" % @scores[[pers_n,prod_n]])
        high_mark = @path.include?([pers_n, prod_n]) ? '*' : ''
        s = high_mark + s
        print(s.rjust(7))
      end
      puts
    end
  end
  
  def total_score
    @path.inject(0.0) {|sum, pos | sum + @scores[pos]}
  end
end  

def calc_total_ss_score(persons, products)
  scores = Scores.new(persons, products)
  scores.sort_matrix
  #scores.print_matrix
  return scores.total_score
end

# Main
unless ARGV[0].nil?
  File.open(ARGV[0]).each_line do |line|
    line.strip!
    next if line.empty? || line[0] == '#'
    inputs = line.split(';')
    puts "%.2f" % calc_total_ss_score(inputs[0].split(','), inputs[1].split(','))
  end
end

