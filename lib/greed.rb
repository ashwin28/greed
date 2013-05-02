require "greed/version"
require "greed/lib/greed/player.rb"

module Greed
  def score(dice)
	  # modified this method so it returns score and number of scoring dice
	  score = [0, 0]
	  # roll up to five dice
	  return score if dice.empty? || dice.size > 5
	  
	  # count the diff rolls and add to hash
	  rolls = Hash.new(0)
	  dice.each do |i|
	    rolls[i] += 1
	  end

	  # iterate through all the rolled values to determine points
	  rolls.each do |value, count|
	    if count >= 3 && value == 1
	      score[0] += 1000
	      score[1] += 3
	      count -= 3
	    elsif count >= 3
	      score[0] += value * 100
	      score[1] += 3
	      count -= 3
	    end
	      
	    case value
	    when 1
	      score[0] += 100 * count
	      score[1] += count
	    when 5
	      score[0] += 50 * count
	      score[1] += count
	    else
	      # zero points
	    end
	  end
	  score
	end

	# simple main menu
	def menu
	  system("clear")
	  puts "Welcome to Greed on ruby, a multiplayer dice game using 5 six-sided dice."

	  while true

	    puts "Menu:"
	    puts "1) View Rules"
	    puts "2) Start Game"
	    puts "3) Exit Game"

	    print "\nSelect option: "

	    menu_input = gets.chomp.to_i

	    case menu_input
	    when 1
	      game_rules
	    when 2
	      game = Game.new
	    when 3
	      puts "Thanks for playing, have a good day!"
	      exit
	    else
	      system("clear")
	      puts "Invalid option!"
	      puts "Please enter 1, 2 or 3."
	      continue
	    end
	    
	  end
	end

	# function to display game rules
	def game_rules
  	rules = <<-EOF
Greed is a dice game played among 2 or more players, using 5
six-sided dice.

== Playing Greed

Each player takes a turn consisting of one or more rolls of the dice.
On the first roll of the game, a player rolls all five dice which are
scored according to the following:

  Three 1's => 1000 points
  Three 6's =>  600 points
  Three 5's =>  500 points
  Three 4's =>  400 points
  Three 3's =>  300 points
  Three 2's =>  200 points
  One   1   =>  100 points
  One   5   =>   50 points

A single die can only be counted once in each roll.  For example,
a "5" can only count as part of a triplet (contributing to the 500
points) or as a single 50 points, but not both in the same roll.

The dice not contributing to the score are called the non-scoring
dice.  "3" and "4" are non-scoring dice in the first example.  "3" is
a non-scoring die in the second, and "2" is a non-score die in the
final example.

After a player rolls and the score is calculated, the scoring dice are
removed and the player has the option of rolling again using only the
non-scoring dice. If all of the thrown dice are scoring, then the
player may roll all 5 dice in the next roll.

The player may continue to roll as long as each roll scores points. If
a roll has zero points, then the player loses not only their turn, but
also accumulated score for that turn. If a player decides to stop
rolling before rolling a zero-point roll, then the accumulated points
for the turn is added to his total score.

Before a player is allowed to accumulate points, they must get at
least 300 points in a single turn. Once they have achieved 300 points
in a single turn, the points earned in that turn and each following
turn will be counted toward their total score.

== End Game

Once a player reaches 3000 (or more) points, the game enters the final
round where each of the other players gets one more turn. The winner
is the player with the highest score after the final round.\n
EOF

	  system("clear")
	  puts rules
	  continue
	end

	def continue
	  print "Press enter to continue."
	  input = gets.to_s
	  system("clear")
	end

	menu
end
