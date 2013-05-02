module Greed

  class Player
  	attr_reader :name, :total_points

    def initialize(name)
      @name = name
      @total_points = 0
      @dice = DiceSet.new
  	end

  	def turn
      # players start their with 5 dice and 0 accumulated points
      dice_left = 5
      accumulated_points, scoring_dice = 0
      system("clear")
      puts @name + " starts the turn with a total of " + @total_points.to_s + " points."

      while true

      	roll = @dice.roll(dice_left)
      	puts "You rolled #{roll.to_s}."
      	points, scoring_dice = score(roll)
      	# If all of the thrown dice are scoring, then the player may roll all 5 dice in the next roll.
      	dice_left = scoring_dice == 5 ? 0 : dice_left - scoring_dice

      	puts "Accumulated points before the roll: #{accumulated_points}"
      	puts "You scored #{points} points and have #{dice_left} non-scoring #{dice_left == 1 ? "die" : "dice"} left."

      	if points == 0
          # If a roll has zero points, then the player loses their turn and all accumulated points for that turn.
          puts "Your roll scored 0 points and accumulated score for this turn is 0."
          return continue
      	elsif accumulated_points + points + @total_points >= 300 && dice_left > 0
          # can roll again
          puts "Do you wish to roll again or bank your points?"

          while true
            print "Enter roll or bank: "
            input = gets.chomp

            case input.downcase
            when "roll"
              system("clear")
              puts @name + " rolls again.\n"
              accumulated_points += points
              break # to exit the error check loop
            when "bank"
              accumulated_points += points
              puts @name + " earns #{accumulated_points} points this turn."
              @total_points += accumulated_points
              return continue
            else
              # add error checking later
              puts "Invalid command!"
            end
          end
      	elsif accumulated_points + points + @total_points >= 300 && dice_left == 0
          
          # player has no dice left to roll, auto banks
          accumulated_points += points
          puts @name + " earns #{accumulated_points} points this turn."
          @total_points += accumulated_points
          return continue
        else
          puts "You need to score a minimum of 300 points in a turn to start accumulating points!"
          puts "Do you wish to roll again or end your turn?"

          while true
            print "Enter roll or end: "
            input = gets.chomp

            case input.downcase
            when "roll"
              system("clear")
              puts @name + " rolls again."
              accumulated_points += points
              break # to exit the error check loop
            when "end"
              puts @name + " earns 0 points this turn."
              return continue
            else
              # add error checking later
              puts "Invalid command!"
            end
          end
        end# if statement
      end# while loop
    end# turn method
  end# Player class

  class Game

    def initialize
      @players = Array.new
      system("clear")
      print "Enter the number of players:"

      while true
        n = gets.chomp.to_i

        if n >= 2 && n <= 15
          break
        else
          puts "Please enter a number between 2 and 15!"
        end
      end
      
      n.times do |x|
        print "Enter player#{x + 1}'s name: "
        temp_name = gets.chomp
        # store players as objects in an array
        @players << Player.new(temp_name)
      end

      system("clear")
      puts "The players are:"
      @players.each do |x|
        puts x.name
      end
      puts "\nStarting game!"

      continue
      self.start
    end

    def start
      while true
        @players.each do |x| 
          x.turn
          if self.check_score
            # normal play
          else
            # someone got >= 3000 points
            puts "Time for final round!"
            continue
            # send the player who has >= 3000 points to final_round
            self.final_round(x)
          end
        end
      end
    end

    def final_round(skips_turn)
      # other players are allowed a turn
      @players.each do |x| 
          x.turn if x != skips_turn
        end

      winner = skips_turn

      # display's the  score for all players
      # NOTE: The winner is the player with the highest score after the final round.
      # I am assuminng that in the case of a draw, the first player to have reached the highest score wins.
      @players.each do |x|
        puts "#{x.name} finished with #{x.total_points} points."
        winner = x if x.total_points > winner.total_points
      end

      puts "\n#{winner.name} wins with #{winner.total_points} points."
      continue
      menu
    end

    # used to decide the final round
    def check_score
      @players.each do |x|
        return false if x.total_points >= 3000
      end
      true
    end
  end

  class DiceSet
  # code ...
    attr_reader :values

    def roll(n)
      @values = n.times.map { rand(1000) % 6 + 1 }
    end
  end

end