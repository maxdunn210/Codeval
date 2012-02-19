# CodeEval String Permutations
#
# Author: Max Dunn
# Email: max@maxdunn.com
# Date: Feb 1, 2012
#
# Strategy: build layers. 
# For each successive layer, take the new character and walk it through each character in the 
# lower "block". Then pop that letter and call it recursively with the new layer
#
# Visualization:
#
# c >            c
# b >          bc,cb
# a > abc,bac,bca,acb,cab,cba

def self.build(s, layer = [])
  return layer if s.empty? # end recursion once s is empty
  
  ch = s[-1] # pop the last character
  
  # special case first layer, it has only 1 block
  # otherwise, take all blocks in the previous layer and create a new layer
  if layer.empty? 
    new_layer = [ch]
  else
    new_layer = []
    layer.each do |block_str|
      0.upto(block_str.length) do |pos|
        new_layer << block_str.dup.insert(pos, ch) # the dup is necessary so it doesn't update previous blocks
      end
    end
  end
  return build(s.chop, new_layer) # recursively build the next layer
end

# Main
unless ARGV[0].nil?
  File.open(ARGV[0]).each_line do |line|
    line.strip!
    next if line.empty?
    puts build(line).sort.join(',')
  end
end



