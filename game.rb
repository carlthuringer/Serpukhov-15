# The game!

class GameBoard
  # Generic 2-d game board.
  # ALERT all code here should be agnostic to any rectangular board-based game.
  # @board keeps an array of the current state of the board.
  #TODO Implement 2-dimensional boards of variable dimension.
  attr_reader :board
  def initialize(board = [])
    # We allow a predefined board to be passed in as an array.
    @board = board
    # Because we'll soon need to address the array by position, I want to make sure it either has a complete board, or re-initialize it with 9 nil objects.
    if @board.nil? || @board.length != 9
      @board = Array.new(9)
    end
  end

  def [](index)
    # Fancy method! Allows you to treat any GameBoard object like an array and access the internal @board array.
    @board[index]
  end

  def mark(symbol, address)
    #Symbol is provided by the player. Presumably an X or O.
    #address is currently restricted to a single digit identifying a place on the array.
    if @board[address].nil?
      @board[address] = symbol
    else
      raise ArgumentError.new("Location is already marked.")
    end
  end
end

class NoughtsAndCrosses
  # Noughts And Crosses
  # The generally English-European name for Tic-Tac-Toe.
  # The game has two players, two symbols (X and O), and is played on a 3x3 grid.
  # Players alternate, with X going first. Each player makes a single mark in an unmarked space.
  # To achieve a win, a player must place the last symbol to form a row, column or diagonal of concurrent, identical symbols.
  # If neither player has achieved a win by the 9th turn, the game ends in a tie.
  attr_reader :winner, :board, :turn, :players
  def initialize(player1, player2)
    @current_game_board = GameBoard.new
    @winner = nil
    @board = @current_game_board.board
    @player1 = [player1, 'X']
    @player2 = [player2, 'O']
    @players = [@player1, @player2]
    @turn = 1
    @history = []
  end

  def currentPlayer
    # As you'll see later, the players array is reversed to facilitate the switching of the current player.
    # I think this is clever, and that it will also be more trouble than it was worth. :D
    # Edit: IT WAS. O_O
    @turn % 2 == 0 ? @players[1][0] : @players[0][0]
  end

  def play(address)
    # @param address is the array index which the player wishes to mark (or attempt marking)
    # First of all, determine if the game is already over. If we've set a winner or are past turn 9, the method ends.
    # Though, hopefully, the second condition is never necessary.
    if @winner.nil? && @turn <= 9
      # Ternary: If @turn is even, O. Else, X.
      @turn % 2 == 0 ? @current_game_board.mark('O', address) : @current_game_board.mark('X', address)
      # Just marked up the board. Check for a winner.
      checkWinner
      # That's one turn. Turn counter + 1.
      @turn += 1
      # Finally, if we just finished the 9th turn, then @turn will be 10.
      # Therefore, there are no more moves left. Check to see if @winner is still nil.
      # If both are true, then that's it. Set winner to a tie game.
      @turn > 9 and @winner.nil? ? @winner =  'tie' : nil
    end
  end

  def checkWinner
    board_slices = winSlicer
    board_slices.each_index do |index|
      if board_slices[index].uniq.length == 1 and not board_slices[index][0].nil?
        if @turn % 2 == 0
          @winner = @players[1][0]
        else
          @winner = @players[0][0]
        end
      end
    end
  end

  def winSlicer
    # winslicer ref: 0 = h1, 1 = h2, 2 = h3, 3 = v1, 4 = v2, 5 = v3, 6 = d\ 7 = d/
    board_slices = [
      @current_game_board.board[0, 3],
      @current_game_board.board[3, 3],
      @current_game_board.board[6, 3],
      [@current_game_board.board[0], @current_game_board.board[3], @current_game_board.board[6]],
      [@current_game_board.board[1], @current_game_board.board[4], @current_game_board.board[7]],
      [@current_game_board.board[2], @current_game_board.board[5], @current_game_board.board[8]],
      [@current_game_board.board[0], @current_game_board.board[4], @current_game_board.board[8]],
      [@current_game_board.board[6], @current_game_board.board[4], @current_game_board.board[2]]
    ]
  end

  def checkTie

  end

  def newGame
    # Reset the state of the game, and save the current game and winner to the history.
    @history << {
      'board' => @current_game_board,
      'winner' => @winner.clone
    }
    @current_game_board = GameBoard.new
    @board = @current_game_board.board
    @winner = nil
    @turn = 1
    @player1, @player2 = @player2, @player1
    @player1[1] = 'X'
    @player2[1] = 'O'
    @players= [@player1, @player2]

  end

  def convertCoord(coord)
    coord = coord.to_s.upcase
    translation_matrix = [
      "A1", "B1", "C1",
      "A2", "B2", "C2",
      "A3", "B3", "C3"
    ]

    case coord.length
    when 1
      return translation_matrix[coord.to_i]
    when 2
      new = 0
      if translation_matrix.index(coord) or translation_matrix.index(coord.reverse)
        translation_matrix.each_index do |index|
          if coord == translation_matrix[index] or coord.reverse == translation_matrix[index]
            new = index
            return new
          end
        end
      else
        raise ArgumentError.new("Your coordinate was invalid.")
      end
    end

  end

end

class TicTacToeStrategy
  # Only for use with NoughtsAndCrosses game. Do not use with GlobalThermonuclearWar.
  # 2-9-1972, 14:55, <v.Chernobrov> Time machine project retrieved vital American plans from future for perfect Tic-Tac-Toe strategy.
  # 4-8-1982, 09:23, <g.Adelson-Velsky> I just looked this over. Tic-Tac-Toe is what Americans call Noughts and Crosses. You're wasting your time loading it into Oko.
  # 6-23-1983, 03:02, <n.Brusentsov> I finished the implementation. Had a lot of time on my hands while waiting for satellite realignment.
  def initialize

  end

  #  Win: If the player has two in a row, play the third to get three in a row.
  #  Block: If the opponent has two in a row, play the third to block them.
  #  Fork: Create an opportunity where you can win in two ways.
  #  Block opponent's fork:
  #  Option 1: Create two in a row to force the opponent into defending, as long as it doesn't result in them creating a fork or winning. For example, if "X" has a corner, "O" has the center, and "X" has the opposite corner as well, "O" must not play a corner in order to win. (Playing a corner in this scenario creates a fork for "X" to win.)
  #  Option 2: If there is a configuration where the opponent can fork, block that fork.
  #  Center: Play the center.
  #  Opposite corner: If the opponent is in the corner, play the opposite corner.
  #  Empty corner: Play in a corner square.
  #  Empty side: Play in a middle square on any of the 4 sides.

  def playSmartly(game)
    case game.turn % 2
    when 1
      my_mark = 'X'
      their_mark = 'O'
    when 0
      my_mark = 'O'
      their_mark = 'X'
    end
    # implemented strategies in reverse order of priority.
    # Tactics Legend
    # B: Block opponent's win
    # C: Play random corner
    # D: Force opponent to defend
    # E: Play center
    # F: Set up a fork
    # O: Play opposite corner
    # R: Random Play
    # S: Play random side
    # T: Stop a fork in progress
    # W: Win

    # Play an empty side
    suggested_move = playEmptySide(game, my_mark)
    my_move, tactic = suggested_move, 'S' unless suggested_move.nil?
    # Play an empty corner
    suggested_move = playEmptyCorner(game, my_mark)
    my_move, tactic = suggested_move, 'C' unless suggested_move.nil?
    # Play corner opposite the opponent's corner mark.
    suggested_move = playOpposingCorner(game, my_mark)
    my_move, tactic = suggested_move, 'O' unless suggested_move.nil?
    # Play the center
    suggested_move = playCenter(game, my_mark)
    my_move, tactic = suggested_move, 'E' unless suggested_move.nil?
    # Make a play that forces opponent to defend.
    suggested_move = forceDefense(game, my_mark)
    my_move, tactic = suggested_move, 'D' unless suggested_move.nil?
    # Set up a fork
    suggested_move = forkYou(game, my_mark)
    my_move, tactic = suggested_move, 'F' unless suggested_move.nil?
    # Block opponent's fork
    suggested_move = stopFork(game, my_mark)
    my_move, tactic = suggested_move, 'T' unless suggested_move.nil?
    # Play opponent's winning move. Blocking it.
    suggested_move = checkForWin(game, their_mark)
    my_move, tactic = suggested_move, 'B' unless suggested_move.nil?
    # Play own winning move.
    suggested_move = checkForWin(game, my_mark)
    my_move, tactic = suggested_move, 'W' unless suggested_move.nil?

    unless my_move.nil?
      game.play(my_move)
      return [ my_move, tactic ]

    else
      begin
        my_move = playRandomly # Legacy last-ditch effort.
        game.play(my_move)
      rescue
        retry
      end
      return [ my_move, 'R' ]
    end
  end

  def checkForWin(game, mark)
    # New tactic. Slice the board up. Slices 0-2 are horizontal, 3-5 vertical, 6 and 7 diagonal.
    target = {
      'slice' => nil,
      'opening' => nil
    }
    board_slices = game.winSlicer
    board_slices.each_index do |index|
      # Here's the plan. Check each slice for a nil (blank space) and two different indexes on 'mark'.
      # This should confirm a row, column, or diagonal which is one move away from a win by 'mark'.
      # Then, somehow, extract the index of the blank space.
      if board_slices[index].index(nil)
        if board_slices[index].index(mark) != board_slices[index].rindex(mark)
          target['slice'], target['opening'] = index, board_slices[index].index(nil)
        end
      end
    end
    unless target['slice'].nil?
      # Translate all the 'openinigs' into an array index.
      case target['slice']
      when 0..2 then return target['slice'] * 3 + target['opening']
      when 3..5 then return (target['slice'] - 4) + (target['opening'] * 3) + 1
      when 6 then return target['opening'] * 4
      when 7 then return 6 - (target['opening'] * 2)
      end
    else
      return nil
    end
  end

  def forceDefense(game, mark)
    # We'll scan the slices for my 'mark'
    # If those slices can be compacted to length 1, we're alone in them.
    # Then pick a random target from the remaining nils and return its array index.
    target = {
      'slice' => nil,
      'opening' => nil
    }
    board_slices = game.winSlicer
    board_slices.each_index do |index|
      if board_slices[index].compact.length == 1 && board_slices[index].index(mark)
        targets = [ { 'slice' => index, 'opening' => board_slices[index].index(nil) }, { 'slice' => index, 'opening' => board_slices[index].rindex(nil) } ]
        target = targets[rand(2)]
      end
    end
    unless target['slice'].nil?
      # Translate all the 'openinigs' into an array index.
      case target['slice']
      when 0..2 then return target['slice'] * 3 + target['opening']
      when 3..5 then return (target['slice'] - 4) + (target['opening'] * 3) + 1
      when 6 then return target['opening'] * 4
      when 7 then return 6 - (target['opening'] * 2)
      end
    else
      return nil
    end
  end

  def stopFork(game, mark)
    # Well. This requires the program to look into the future.
    # There are exactly two fork defense scenarios for player 2.
    # X has always taken a center and a corner when preparing to fork.
    # One: X marked a corner. You took center. X is in opposite corner.You must play a side to prevent the fork.
    # Two: X marked the center. You took a corner. You must play a corner to prevent the fork.
    board_slices = game.winSlicer
    # winslicer ref: 0 = h1, 1 = h2, 2 = h3, 3 = v1, 4 = v2, 5 = v3, 6 = d\ 7 = d/
    if board_slices[6].compact.length == 3 or board_slices[7].compact.length == 3
      case game.board.index(mark)
      when 4 then return playEmptySide(game, mark)
      else return playEmptyCorner(game, mark)
      end
    else return nil
    end
  end

  def forkYou(game, mark)
    # See what I did there?
    if game.turn == 3
      case game.board.index(mark)
      when 4 then return playOpposingCorner(game, mark)
      else return playCenter(game, mark) if game.board[4].nil?
      end
    else return nil
    end
  end

  def playCenter(game, mark)
    4 if game.board[4].nil?
  end

  def playOpposingCorner(game, mark)
    corners = [0, 2, 6, 8]
    mark == 'X' ? opponent_mark = 'O' : opponent_mark = 'X'
    opponent_in_corner = game.board.index(opponent_mark)
    case opponent_in_corner
    when 0 then return 8 if game.board[8].nil?
    when 2 then return 6 if game.board[6].nil?
    when 6 then return 2 if game.board[2].nil?
    when 8 then return 0 if game.board[0].nil?
    else
      return nil
    end

  end

  def playEmptyCorner(game, mark)
    corners = [0, 2, 6, 8]
    empty_corners = []
    corners.each do |corner|
      empty_corners << corner if game.board[corner].nil?
    end
    if empty_corners[0].nil?
      nil
    else
      return empty_corners[rand(empty_corners.length)]
    end
  end

  def playEmptySide(game, mark)
    sides = [1, 3, 5, 7]
    empty_sides = []
    sides.each do |side|
      empty_sides << side if game.board[side].nil?
    end
    if empty_sides[0].nil?
      nil
    else
      return empty_sides[rand(empty_sides.length)]
    end
  end

  def playRandomly
    # Doesn't get much simpler than this!
    return rand(9)
  end

end

class Player
  # I intend to hold some info about the player... like a name or something. Win/loss history maybe?
  def initialize(name)
    @name = name
    @status = "Moves: "
  end
  attr_reader :name, :status

  def play(game, input)
    game.play(game.convertCoord(input))
    @status << input + ","
  end

  def resetStatus
    @status = "Moves: "
  end

end

class AI < Player
  #Class that will have some methods and stuff, planning ahead for a much more interesting AI character.
  # Might be good to make this a child of the Player class?
  # If more games are implemented, I'll want to have it load strategies dynamically.
  def initialize(name)
    super name
    @strategy = TicTacToeStrategy.new
  end

  def play(game)
    # Pass the game along... This method ought to work with any @strategy loaded.
    result = @strategy.playSmartly(game)
    @status << game.convertCoord(result[0]) + "-" + result[1] + ","
  end
end

def simpleDraw(board)
  # The collect method is used to find and replace in an array. In this case, find Nil, replace with " ".
  clean_board = board.collect { |obj| obj.nil? ? " " : obj }
  print "   A  B  C\n"
  3.times { |index|
    row = index + 1
    print row.to_s + " "
    # Array[index, length]. It's a good thing. Spit this out thrice and it almost looks like a tic tac toe board!
    clean_board[3 * index, 3].each do |cell|
      print "[" + cell + "]"
    end
    print "\n"
  }
end

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
  # ticTacToeRules
  # gets
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
          simpleDraw(game.board)
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
    simpleDraw(game.board)

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

def mainProgram
  @START = Time.utc(1983,"sep",25,20,28,1)
  @DIFF = Time.new - @START
  @L1 = Time.utc(1983,"sep",25,20,30,1)
  @L2 = Time.utc(1983,"sep",25,20,34,1)
  @X = Time.utc(1983,"sep",25,20,45,1)
  system("clear")
  #Do the welcome screen...
  #if (Time.now - @DIFF <=> @L1) == -1
     welcomeScreen(Time.now - @DIFF)
  #end

  print "\nLogin\nUser: "
  print "s.petrov"
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
    #if (Time.now - @DIFF <=> @L1) == -1
      welcomeScreen(Time.now - @DIFF)
    #end
    print %{
Programs:
  1) Chess
  2) Noughts and Crosses
  3) Global Thermonuclear War
  4) Emergency Line
  q) Quit}
    print "\nOut of memory error" if prompt == '1'
    print "\nMainframe Computing Time Allowance Exceeded. Contact Central Research." if prompt == '3'
    print "\nChoice?"
    prompt = gets.chomp!

    playNAC if prompt == '2'
  end
end

# For fun, some stuff.
require 'texts'

mainProgram