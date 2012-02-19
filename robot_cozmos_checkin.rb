# CodeEval Robot
#
# Author: Max Dunn
# Company: Cozmos
# Email: max@maxdunn.com
# Date: Feb 7, 2012
#
# Strategy: First tried to do an exhaustive search of all possible paths then weed out those that don't start and end
# at the correct place, or those that are not contiguous. However, for a 4x4 grid, there will be 16! (factorial) possible
# paths which is a very big number and would take too long to compute.
#
# Next I started working on a random path algorithm. Just start at the beginning, then take a drunken walk through
# the grid and see if you get stuck or end up at the end. This would be an interesting way of solving this, but would
# be hard to detect when done.
#
# Finally, worked on a recursive solution where we start at 0,0 then look at all moves from there and recurse on that.
# Didn't have enough time to complete this, but it looks promising as long as we don't get a stack that is too deep

ROWS = 4
COLS = 4

def contiguous(path)
  last_pos = []
  path.each do |pos|
    if last_pos.empty?
    last_pos = pos
    else
    # If we made just one horizontal or vertical move, the absolute value of difference in the pos from the
    # last pos (both row and col) will equal 1
      unless 1 == ((pos.first.abs - last_pos.first.abs) + (pos.last.abs - last_pos.last.abs))
      return false
      end
    end
  end
  return true
end

# Use convention: pos = [row, col]

def all_paths

  # First setup the grid
  grid = []
  0.upto(ROWS - 1) do |row|
    0.upto(COLS - 1) do |col|
      grid << [row, col]   #!!!! This is too big! 16 factorial is a very large number
    end
  end

  # Now get all possible paths covering every square, but not necessarily continuous
  paths = grid.permutation(ROWS * COLS).to_a

  # Get rid of those that don't start at 0,0 or end at 3,3
  paths.delete_if {|path| path.first != [0, 0] || path.last != [ROWS - 1, COLS - 1]}

  # Now delete all non-contiguous paths
  paths.delete_if {|path| !contiguous(path)}

  # count what's left
  return paths.count
end

def next_random_pos(pos, path, paths)
  tried = ''
  new_pos = pos.dup
  while true do
    horizontal_dir = random(1)
    add_sub = random(1) ? 1 : -1
    if horizontal_dir
    new_pos.first = new_pos.first + add_sub
    else
    new_pos.last = new_pos.last + add_sub
    end

    # Got to here. Rest is pseudo code
    if !(already_tried_dir || out_of_bounds || looping_back_on_same_path || already_been_down_this_path)
    return pos
    end
  end
end

def random_walk
  paths = []
  # Here is an interesting part - how many times do we try? Could look at success rate and once it gets to a certain
  # number of failed attempts since the last successful attempt, stop
  while failed_attempts < some_number do
    pos = [0,0]
    path = []
    while !pos.nil? && path.length < ROWS * COLS do
      path << pos
      pos = next_random_pos(pos, path, paths)
    end
    paths << path
  end
  return paths.length
end

def check_and_recurse(next_pos, path, paths)
  if !path.include?(next_pos)
    path << next_pos
    recurse_path(next_pos, path, paths)
  end
end

def recurse_path(pos, path = [], paths = [])
  next_pos = pos.dup

  while path.length < ROWS * COLS
    if pos.first > 0
      next_pos = [pos.first - 1, pos.last]
      check_and_recurse(next_pos, path, paths)
    end
    if pos.first < COLS - 1
      next_pos = [pos.first + 1, pos.last]
      check_and_recurse(next_pos, path, paths)
    end
    if pos.last > 0
      next_pos = [pos.first, pos.last - 1]
      check_and_recurse(next_pos, path, paths)
    end
    if pos.last < COLS - 1
      next_pos = [pos.first, pos.last + 1]
      check_and_recurse(next_pos, path, paths)
    end
  end

  if pos.first == ROWS - 1 && pos.last == COLS - 1
  paths << path
  end

  return paths.length
end

puts recurse_path([0,0])
