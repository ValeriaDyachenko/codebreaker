require "codebreaker/version"

module Codebreaker
  class Game
    attr_accessor :secret_number, :player_guess, :attempt,  :array_guess_number, :plus_minus, :attempt_save , :index
    
    def start
      puts 'Welcome to Codebreaker!'  
      code_generation 
      start_the_game
    end
          
    def code_generation
      @secret_number = Array.new(4){ rand(6)+1 } 
    end
                    
    def start_the_game
      puts 'For help enter HINT.For continue the game enter START.'  
      answ_up = gets.chomp
        if answ_up == "HINT" 
          hint
          user_play
        elsif answ_up == "START" 
          user_play
        else
          exit
        end
    end
      
    def hint
      puts "The first number is: #{@secret_number.first}"
    end
    
    def user_play
      @attempt = 1
      game_loop
      player_loser
    end
 
    def game_loop 
      while @attempt < 16
        @array_player_guess = []
        puts "Enter please #{@attempt} guess. 4 Numbers in range 1..6" 
        @player_guess = gets.chomp
        if /[\d]{4}/ =~ @player_guess  
          @array_player_guess = @player_guess.split('').map {|element| element.to_i}
        else
          print "Error!Should be only 4 Numbers in range 1..6.For help enter HINT.For continue the game click enter\n"
          answ_hint = gets.chomp
          hint if answ_hint == "HINT"
          game_loop
        end  
        index_loop
        if @array_player_guess == @secret_number
          player_win 
          break
        end
        @attempt += 1   
      end
    end
    
    def index_loop
      index = 0
      @plus_minus =[]        
      while  index < 4
        if @array_player_guess[index] == @secret_number[index]
          @plus_minus << '+'
        elsif @secret_number.include?(@array_player_guess[index])
          @plus_minus <<  '-'            
          end
          index +=1
      end
      puts "#{@plus_minus.sort.join(' ').split('  ')}"   
    end
 
    def player_win
      puts "You won!Ba-na-na!=)"
      saves_result
    end

    def player_loser 
      puts "You lost!"
      puts "Here is the secret code: #{@secret_number}"    
      puts "By by loser!"
      saves_result
    end
    
    def saves_result
      puts "Do you want to save the result??If YES enter Y,if NO enter N"
      answ_sr = gets.chomp
      if answ_sr == "Y"
        save_to_file
        play_again
      elsif answ_sr == "N"
        play_again
      else
        puts "Error,Enter your answer again"
        saves_result
      end
    end

    def save_to_file
      puts "Enter your name"
      name = gets.chomp
      File.open "result.txt", "a" do |file|
        file.write("Player name: #{ name }   Attempt: #{ @attempt }   Secret_number: #{ @secret_number }\n")
        puts "The data is stored"
      end
    end

    def play_again
      puts "Would you like to play again?If YES enter Y,if NO enter N"
      answ_pa = gets.chomp
      if answ_pa == "Y"
        start
      elsif answ_pa == "N"
        exit
      else
        puts "Error,Enter your answer again"
        play_again
      end
    end           
  end
end
