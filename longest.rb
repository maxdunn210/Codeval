# CodeEval Longest Common Subsequence 
#
# Author: Max Dunn
# Email: max@maxdunn.com
# Date: Feb 3, 2012
#
# Strategy: See if the characters match, if so then return that character plus the match of the rest of the strings
# If the characters don't match, return the largest substring of sliding s1 and s2
# However, this results in computing the same substring multiple times so cache the results for performance

def slide_cache(s1, s2, p1 = 0, p2 = 0)
  @cache = {} if !defined?(@cache) || (p1 == 0 && p2 == 0)
  return @cache[[p1,p2]] ||= slide(s1, s2, p1, p2) 
end

def slide(s1, s2, p1 = 0, p2 = 0)
  return '' if p1 == s1.length || p2 == s2.length
  
  if s1[p1] == s2[p2]
    return s1[p1] + slide_cache(s1, s2, p1 + 1, p2 + 1) 
  end
  sub1 = slide_cache(s1, s2, p1 + 1, p2)
  sub2 = slide_cache(s1, s2, p1, p2 + 1)
  if sub1.length > sub2.length
    return sub1
  else
    return sub2
  end
end

# Main
unless ARGV[0].nil?
  File.open(ARGV[0]).each_line do |line|
    line.strip!
    next if line.empty?
    num_array = line.split(';')
    puts slide_cache(num_array[0], num_array[1])
  end
end

