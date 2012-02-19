# CodeEval Spiral Printing
#
# Author: Max Dunn
# Company: Cozmos
# Email: max@maxdunn.com
# Date: Feb 7, 2012

class SpiralStateMachine
  def initialize(rows, cols)
    @rows, @cols = rows, cols
  end

  def init_state
    return {:row => 0, :col => 0, :dir => 'east', 
      :east_bound => @cols - 1, :west_bound => 0, :south_bound => @rows - 1, :north_bound => 0}
  end
  
  # Note: With more time, would convert this to a more generic state machine with the transitions and 
  # tests contained in the state itself
  def next_state(state)
    if state[:dir] == 'east'
      if state[:col] < state[:east_bound]
        state[:col] += 1
      else
        state[:north_bound] += 1
        state[:row] += 1
        state[:dir] = 'south'
      end
    elsif state[:dir] == 'south'
      if state[:row] < state[:south_bound]
       state[:row] += 1
      else
        state[:east_bound] -= 1
        state[:col] -= 1
        state[:dir] = 'west'
      end
    elsif state[:dir] == 'west'
      if state[:col] > state[:west_bound]
        state[:col] -= 1
      else
        state[:south_bound] -= 1
        state[:row] -= 1
        state[:dir] = 'north'
      end
    else # state[:dir] == 'north
      if state[:row] > state[:north_bound]
        state[:row] -= 1
      else
        state[:west_bound] += 1
        state[:col] += 1
        state[:dir] = 'east'
      end
    end
    return state
  end
  
end

def spiral_print(rows, cols, char_array)
  spiral_state_machine = SpiralStateMachine.new(rows, cols)
  state = spiral_state_machine.init_state

  output = []
  while true do
    output << char_array[(state[:row] * cols) + state[:col]]
    break if output.length == char_array.length
    
    state = spiral_state_machine.next_state(state)
 
  end
  
  return output.join(' ')
end

def strip_and_rotate(rows, cols, chars)
  matrix = chars.each
end

# Main
unless ARGV[0].nil?
  File.open(ARGV[0]).each_line do |line|
    line.strip!
    next if line.empty? || line[0] == '#'
    inputs = line.split(';')
    puts spiral_print(inputs[0].to_i, inputs[1].to_i, inputs[2].split(' '))
  end
end
