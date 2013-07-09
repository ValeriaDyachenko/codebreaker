require "codebreaker.rb"

module Codebreaker
  describe Game do
    let(:game)   { Game.new} 

    context  "#start" do
      before(:each) {game.stub(:start_the_game)}
        it "running the game" do
          game.should_receive(:puts)
          game.start
        end  
  
        it "call code_generation" do
          game.should_receive(:code_generation)
          game.start        
        end
        
        it "call start_the_game" do
          game.should_receive(:start_the_game)
          game.start
        end
    end

    context  "#code_generation" do
        it "secret_number should have 4 items" do
          game.code_generation
          game.secret_number.should have(4).items
        end

        it "every items of secret_number should be in range 1..6" do
          game.code_generation
          game.secret_number.each {|x| x.should be_between(1,6) }
        end
    end

    context  "#start_the_game" do
      it "should call hint" do
        game.stub(:hint)
        game.stub(:user_play)
        game.stub(:gets).and_return('HINT')
        game.should_receive(:hint)
        game.start_the_game
      end

      it "should call user_play" do
        game.stub(:hint)
        game.stub(:user_play)
        game.stub(:gets).and_return('HINT')
        game.should_receive(:user_play)
        game.start_the_game
      end

      it "should call user_play" do
        game.stub(:gets).and_return('START')
        game.should_receive(:user_play)
        game.start_the_game
      end

      it "should call exit" do
        game.stub(:gets).and_return('')
        game.should_receive(:exit)
        game.start_the_game
      end
    end

    context  "#hint" do
      it "should show hint" do 
        game.code_generation
        game.stub(:gets).and_return('HINT')
        game.should_receive(:puts)
        game.hint
      end
    end

    context  "#user_play" do
      it "Processing user_play" do 
        game.attempt = 1
        game.should_receive(:game_loop)
        game.should_receive(:player_loser)
        game.user_play
      end
    end

    context  "#game_loop" do
      
      before(:each) do 
        game.attempt = 1
        game.secret_number = [1, 2, 3, 4]
        game.stub(:saves_result)
      end

      it "player guess should have 4 numbers" do
        game.stub(:gets).and_return("1234")
        game.game_loop
        game.player_guess.size.should eql(4)
      end

      it "player guess should be numbers" do
        game.stub(:gets).and_return("1d34", "1234")
        game.should_receive(:print).with("Error!Should be only 4 Numbers in range 1..6.For help enter HINT.For continue the game click enter\n")
        game.game_loop 
      end

      it "player guess should be convert to array" do
        game.instance_variable_set(:@array_player_guess, [])
        game.stub(:gets).and_return("1234") 
        game.game_loop
        game.instance_variable_get(:@array_player_guess).should eql([1,2,3,4])
      end
      
      it "should call index_loop" do
        game.stub(:gets).and_return("1234")
        game.stub(:index_loop)
        game.should_receive(:index_loop)
        game.game_loop
      end

      it "player win" do
        game.stub(:gets).and_return("1234")
        game.stub(:index_loop)
        game.should_receive(:player_win)
        game.game_loop
      end
    end

    context  "#index_loop" do 
      it "Processing index_loop" do 
        game.instance_variable_set(:@secret_number, [1, 3, 2, 4])    
        game.instance_variable_set(:@array_player_guess, [1, 2, 3, 4])    
        game.index_loop
        game.plus_minus.should eql(["+", "-", "-", "+"])        
      end
    end
    
    context "#player_win" do
      it "should show Ba-na-na" do
        game.should_receive(:puts).with("You won!Ba-na-na!=)")
        game.stub(:saves_result)
        game.player_win
      end

      it "should call saves_result " do
         game.should_receive(:saves_result)
         game.player_win
      end
    end

    context "#player_loser" do
      it "should show You lost!" do
        game.should_receive(:puts).exactly(3).times
        game.stub(:saves_result)
        game.player_loser
      end

      it "should call saves_result" do
        game.should_receive(:saves_result)
        game.player_loser
      end
    end

    context "#saves_result" do
      it "should call save_to_file" do
         game.stub(:gets).and_return('Y')
         game.should_receive(:save_to_file)
         game.should_receive(:play_again)
         game.saves_result
      end

      it "should call play_again " do
        game.stub(:gets).and_return('N')
        game.should_receive(:play_again)
        game.saves_result
      end

      it "should call saves_result" do
        game = Game.new.as_null_object
        game.stub(:gets).and_return('', 'N')
        game.stub(:play_again)
        game.should_receive(:puts).with("Error,Enter your answer again")
        game.saves_result
      end
    end

    context "#save_to_file" do
      it "shoud saves result to the file" do
        file = mock('file')
        game.stub(:gets).and_return("Banana")
        File.should_receive(:open).with("result.txt", "a").and_yield(file)
        file.should_receive(:write)
        game.save_to_file
      end
    end

    context  "#play_again" do
      it "should call start" do
        game.stub(:gets).and_return('Y')
        game.should_receive(:start)
        game.play_again
      end

      it "should call exit " do
        game.stub(:gets).and_return('N')
        game.should_receive(:exit)
        game.play_again
      end

      it "should show error message" do
        game = Game.new.as_null_object
        game.stub(:gets).and_return('', 'N')
        game.stub(:exit)
        game.should_receive(:puts).with("Error,Enter your answer again")
        game.play_again
      end
    end
  end
end