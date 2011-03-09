require 'texts' # Contains all text-heavy content for the game.
require 'nac' # All the game logic, sans-story.

def playNAC
  # Pretty much the mainloop of the game.

  big_mac = AI.new("BIGMAC")
  petrov = Player.new("Petrov")
  game = NoughtsAndCrosses.new(big_mac, petrov)
  game_count = 1
  puts "Connecting to BIGMAC"
  puts "Dialing..."
  sleep 2
  puts "Establishing link..."
  sleep 2.5
  puts "BIGMAC: Ah, Lt. Colonel Petrov.\n(Press Enter)"
  gets
  puts "BIGMAC: I always enjoy our time together."
  gets
  print "Shall we play a game? (y/n): "
  prompt = gets
  prompt.chomp!
  system("clear")
  printf(ticTacToeRules)
  gets
  while prompt != 'n' and prompt != 'q'
    system("clear")
    while game.winner.nil?
      game.turn % 2 == 1 ? current_mark = 'X' : current_mark = 'O'
      case game.currentPlayer
      when big_mac
        big_mac.play(game)
      when petrov
        e = ""
        begin
          system("clear")
          puts "Game " + game_count.to_s
          puts "Player " + game.players[0][1] + ": " + game.players[0][0].name + "; " + game.players[0][0].status + "\n"
          puts "Player " + game.players[1][1] + ": " + game.players[1][0].name + "; " + game.players[1][0].status + "\n\n"
          game.simpleDraw()
          puts e
          print "What is the coordinate of your next move? "
          petrov_move = gets.chomp!
          unless petrov_move.length == 2
            raise ArgumentError.new("Invalid Coordinate")
          end
          petrov.play(game, petrov_move)
        rescue StandardError
          $stderr.print $!
          retry
        end
      end

    end
    system("clear")
    puts "Game " + game_count.to_s
    puts "Player " + game.players[0][1] + ": " + game.players[0][0].name + "; " + game.players[0][0].status + "\n"
    puts "Player " + game.players[1][1] + ": " + game.players[1][0].name + "; " + game.players[1][0].status + "\n\n"
    game.simpleDraw()

    if game.winner == 'tie'
      puts "There was no winner this time."
    else
      puts "The winner was " + game.winner.name + "'\n"
    end
    print "Play again? (y/n): "
    prompt = gets
    prompt.chomp!
    game_count += 1
    game.newGame
    game.players.each { |player| player[0].resetStatus}
  end

  puts "BIGMAC: I suppose you can try to show me the meaning of Mutually Assured Destruction another time."
  gets
  puts "BIGMAC: But I believe the only thing that is assured is your losing streak."
  gets
end

def emergencyLine

  puts "Connecting to Moscow"
  puts "Dialing..."
  sleep 2
  puts "Establishing link..."
  sleep 2.5
  print "Transmit code? (y/n):"
  if gets.chomp! == 'y'
    puts "Initiating Missile Launch Sequence."
    sleep 2
    puts "Game Over. The world has been destroyed by nuclear holocaust"
    return "gameover"
  else
    return "continue"
  end
end

def mainProgram
  @START = Time.utc(1983,"sep",25,20,28,1)
  @DIFF = Time.new - @START
  @L1 = Time.utc(1983,"sep",25,20,30,1)
  @L2 = Time.utc(1983,"sep",25,20,34,1)
  @X = Time.utc(1983,"sep",25,20,45,1)
  system("clear")
  #Do the welcome screen...
  printf(welcomeScreen, Time.now - @DIFF)
  print "\nLogin\nUser: "
  print "s.petrov\n(Press Enter)"
  gets
  print "Password: "
  print "*********"
  gets

  prompt = ''
  while prompt != 'q'
    system("clear")
    # 1 safe minute.
    # 11.5 minutes
    #Do the welcome screen...
    if (Time.now - @DIFF <=> @L1) == -1
      printf(welcomeScreen, Time.now - @DIFF)
    else
      printf(warning1, (Time.now - @DIFF - @X).to_i)
    end
    #end
    print %{
Programs:
  1) Chess
  2) Noughts and Crosses
  3) Global Thermonuclear War
  4) Emergency Line
  q) Quit}
    print "\nProgram missing. Contact G.Kasparov" if prompt == '1'
    print "\nMainframe Computing Time Allowance Exceeded. Contact Central Research." if prompt == '3'

    print "\nChoice?"
    prompt = gets.chomp!

    playNAC if prompt == '2'
    if prompt == '4'
      result = emergencyLine
      if result == "gameover"
        prompt = 'q'
      end
    end
    if (Time.now - @DIFF <=> @X) == 1
      prompt = 'q'
      system("clear")
      printf(welcomeScreen, Time.now - @DIFF)
      sleep 3
      puts "Missiles Lost."
      sleep 1
      puts "The missiles being tracked were a bug in the Oko system."
      sleep 3
      puts "By doubting your computer, disobeying procedures and waiting out the malfunction you have saved the free world."
      puts "You win."
    end
  end
end

mainProgram