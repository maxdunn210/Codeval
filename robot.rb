# CodeEval Robot
#
# Author: Max Dunn
# Email: max@maxdunn.com
# Date: Feb 7, 2012
#
# Strategy: Use recursion. Start in the 0,0 square and check in all 4 directions. If any work, then save the 
# state through recursion and check all 4 directions of the next position. Keep going until we get stuck or
# reach the end square. We could just keep a count of the paths, but for debugging purposes it is nice to keep
# all the paths

ROWS = 4
COLS = 4

def check_and_recurse(next_pos, path, paths)
  
  # Check to make sure we haven't visited this square and it is in bounds
  if !path.include?(next_pos) && 
    next_pos.first >= 0 && next_pos.first <= ROWS - 1 && next_pos.last >= 0 && next_pos.last <= COLS - 1
    pos = next_pos
    path << pos
    
    # if at end pos, save path. Otherwise call count_paths recursively
    if (pos.first == ROWS - 1 && pos.last == COLS - 1)
      paths << path.dup
    else
      count_paths(pos, path, paths)
    end      
  end
end

def count_paths(pos = [0,0], path = [], paths = [])
  path << pos if path.empty? # init the path on the first time called
  
  # Look in each direction for valid moves, Call path.dup here to save state
  check_and_recurse([pos.first + 1, pos.last], path.dup, paths)
  check_and_recurse([pos.first - 1, pos.last], path.dup, paths)
  check_and_recurse([pos.first, pos.last - 1], path.dup, paths)
  check_and_recurse([pos.first, pos.last + 1], path.dup, paths)

  return paths.length
end

puts count_paths
