# CodeEval Fizz Buzz
#
# Author: Max Dunn
# Company: Cozmos
# Email: max@maxdunn.com
# Date: Feb 7, 2012

def fizz_buzz(a, b, n)
  game_output = []
  1.upto(n) do |count|
    if count % (a * b) == 0 
      game_output << 'FB'
    elsif count % a == 0
      game_output << 'F'
    elsif count % b == 0
      game_output << 'B'
    else
      game_output << count
    end
  end 
  return game_output.join(' ')
end

# Main
unless ARGV[0].nil?
  File.open(ARGV[0]).each_line do |line|
    line.strip!
    next if line.empty? || line[0] == '#'
    inputs = line.split(' ').map {|num_str| num_str.to_i}
    puts fizz_buzz(inputs[0], inputs[1], inputs[2])
  end
end
