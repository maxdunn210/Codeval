
# build a list of all possible substrings. There will be 2**length of them
def build_substrings(s)
  a = []
  0.upto(2**s.length) do |n|
    # build substring by including positions corresponding to binary digits
    sub = ''
    0.upto(s.length - 1) do |p|
      sub << s[p] if n[p] == 1
    end
    a << sub
  end 
  return a  
end

def find_longest_match(a1, a2)
  a = a1 & a2 # get the common strings
  longest = ''
  a.each do |s|
    longest = s if longest.length < s.length
  end
  return longest
end

#-----------------
def monotone(a)
   last = 0
   a.each do |n|
     return false if n < last
     last = n 
   end
   return true
end

def number_match(s1, s2)
  order = []
  s1.each_char do |c|
    order << s2.index(c)
  end
  
  if s1.length > s2.length
    max_len = s1.length
  else
    max_len = s2.length
  end
  longest_path = []
  compact_order = order.compact

  1.upto(2**(compact_order.length) - 1) do |n|
    path = []
    0.upto(compact_order.length - 1) do |p|
      path << compact_order[p] if n[p] == 1
    end
    
    if monotone(path)
      longest_path = path if longest_path.length < path.length
    end
  end
  
  # Build back string
  ret_str = ''
  longest_path.each do |p|
    ret_str << s2[p]
  end
  
  return ret_str
end

def slide_cache(s1, s2, p1 = 0, p2 = 0)
  @cache = {} if !defined?(@cache) || (p1 == 0 && p2 == 0)
  return @cache[[p1,p2]] if @cache[[p1,p2]]
  return @cache[[p1,p2]] = slide(s1, s2, p1, p2)
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

# Nums:  1,6,7,8,2,4
# Pos:   1-1, 2-6, 3-7, 4-8, 5-2, 6-4
# Pos-1  1-1, 5-2,      6-4,      2-6, 3-7, 4-8
#


def benchmark(s1, s2)
  puts "s1=#{s1}"
  puts "s2=#{s2}"
  puts 
  
  start_time = Time.now
  #match = number_match(s1, s2)
  match = slide_cache(s1, s2)
  duration = Time.now - start_time
  
  puts "Slide match: #{match}"
  puts "Took: #{(duration * 1000).round(5)}ms"
  puts
  
=begin  
  start_time = Time.now
  a1 = build_substrings(s1)
  a2 = build_substrings(s2)
  match = find_longest_match(a1, a2)
  duration = Time.now - start_time
  
  puts "Table match: #{match}"
  puts "Took: #{duration * 1000}ms"
=end  
end



# Main
s1 = 'MZJAWXU'
s2 = 'XMJYAUZ'
#benchmark(s1,s2)
#puts "Should be: MJAU"
#puts

unless ARGV[0].nil?
  File.open(ARGV[0]).each_line do |line|
    line.strip!
    next if line.empty?
    num_array = line.split(';')
    puts slide_cache(num_array[0], num_array[1])
  end
end

