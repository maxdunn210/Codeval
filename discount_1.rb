# CodeEval Discount Offers
#
# Author: Max Dunn
# Email: max@maxdunn.com
# Date: Feb 5, 2012
#
# Strategy: Use the Ruby permutation array method to compute the one-to-one paths for persons and products
# Note: this is O(n!) and takes too long for anything other than small sets

DEBUG = false

def letters(s)
  s.downcase.count('a-z') 
end

def letters_even(s)
  letters(s).even?
end

def vowels(s)
  s.downcase.count('aeiouy')
end

def consonants(s)
  s.downcase.count('a-z', '^aeiouy')
end

def common_factors(s1, s2)
  l1 = letters(s1)
  l2 = letters(s2)
  return l1.gcd(l2) > 1
end

def ss_score(pers, prod)
  score = 0.0
  puts "  #{pers} letters=#{letters(pers)} consonants=#{consonants(pers)} vowels=#{vowels(pers)}" if DEBUG
  puts "  #{prod} letters=#{letters(prod)} consonants=#{consonants(prod)} vowels=#{vowels(prod)}" if DEBUG
  if letters_even(prod)
    score += vowels(pers) * 1.5
    puts "  Prod letters even, score=#{score}" if DEBUG
  else
    score += consonants(pers)
    puts "  Prod letters odd, score=#{score}" if DEBUG
  end
  if common_factors(pers, prod)
    score *= 1.5 
    puts "  Common factors. Score=#{score}" if DEBUG
  end
  return score
end

def calc_scores(persons, products)
  scores = {}
  persons.each_with_index do |pers, pers_n|
    products.each_with_index do |prod, prod_n|
      puts "#{pers};#{prod}" if DEBUG
      scores[[pers_n, prod_n]] = ss_score(pers, prod)
      puts "  Score=#{scores[[pers_n, prod_n]]}" if DEBUG
    end
  end
  return scores
end

def permutations(cols, rows)
  a = []
  (0..cols - 1).each { |n| a << n }
  return a.permutation(rows).to_a
end

def max_score(persons, products)
  if DEBUG
    scores = calc_scores(persons, products)
    (0..(persons.length - 1)).each do |pers_n|
      (0..(products.length - 1)).each do |prod_n|
        print ("%.2f " % scores[[pers_n, prod_n]]).rjust(6)
      end
      puts
    end
  end
  
  good_scores = {}
  if persons.length >= products.length
    permutations(persons.length, products.length).each do |a|
      good_scores[a] = 0
      a.each_with_index do |pers_n, prod_n|
        good_scores[a] += ss_score(persons[pers_n], products[prod_n])
      end
    end
  else
    permutations(products.length, persons.length).each do |a|
      good_scores[a] = 0
      a.each_with_index do |prod_n, pers_n|
        good_scores[a] += ss_score(persons[pers_n], products[prod_n])
      end
    end
  end
  
  high_score = 0
  high_key = []
  good_scores.each do |key, val|
    if high_score < val 
      high_score = val
      high_key = key
    end 
  end
  p high_key if DEBUG
  return high_score
end

#p permutations(4,3)
#puts letters('iPad 2 - 4-pack')
#puts letters_even('iPad 2 - 4-pack')
#puts ss_score('Jack Abraham','iPad 2 - 4-pack')
#puts letters('Girl Scouts Thin Mints')
#puts letters('Jack Abraham')
#puts ss_score('Jack Abraham','Girl Scouts Thin Mints')

# Main
unless ARGV[0].nil?
  File.open(ARGV[0]).each_line do |line|
    line.strip!
    next if line.empty? || line[0] == '#'
    inputs = line.split(';')
    puts "%.2f" % max_score(inputs[0].split(','), inputs[1].split(','))
  end
end

