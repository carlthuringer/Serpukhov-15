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
      # TODO Make this work. We don't allow places to be overwritten. In some potential future, an 'erase' method followed by a 'mark' method will accomplish this.
      throw :inputerror
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
  attr_reader :winner, :board
  def initialize(player1, player2)
    @current_game_board = GameBoard.new
    @winner = nil
    @board = @current_game_board.board
    @player1 = player1
    @player2 = player2
    @players = [@player1, @player2]
    @turn = 1
    @history = []
  end
  
  def currentPlayer
    # As you'll see later, the players array is reversed to facilitate the switching of the current player.
    # I think this is clever, and that it will also be more trouble than it was worth. :D
    @players[0]
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
      # That's one turn. Turn counter + 1. Switch players!
      @turn += 1
      @players.reverse!
      # Finally, if we just finished the 9th turn, then @turn will be 10.
      # Therefore, there are no more moves left. Check to see if @winner is still nil.
      # If both are true, then that's it. Set winner to a tie game.
      @turn > 9 and @winner.nil? ? @winner =  {'winner' => 'tie', 'mark' => 'tie' } : nil
    elsif @turn > 9 || @winner == 'tie'
      # TODO Error handling. If someone tries to play on a tie game, throw.
      #raise "Game ended in a Tie.\nStart a new game."
    else
      # TODO Error handling. If someone tries to play on a finished game. Throw.
      #raise "Game has been won by " + @winner + "\nStart a new game."
    end
    # Above: A lot of this is to protect the programmer... from himself.
  end

  def checkWinner
    # A simple iterator/index with If statements. This is not much shorter than an explicit test for all 6 row/columns.
    # I don't think these lines are long enough. Maybe I should do it with ternary operators. >:)
    #Columns and rows
    (0..2).each do |index|
      #columns
      if @current_game_board[index] == @current_game_board[index+3] and @current_game_board[index] == @current_game_board[index + 6] and not @current_game_board[index].nil?
        #All that matters is we identify the symbol we're testing for concurrence in a row or column.
        @winner['winner'], @winner['mark'] = @player[0], @current_game_board[index]
      end
      #rows
      if @current_game_board[3 * index] == @current_game_board[(3 * index) + 1] and @current_game_board[3 * index] == @current_game_board[(3 * index) + 2] and not @current_game_board[3 * index].nil?
        @winner['winner'], @winner['mark'] = @player[0], @current_game_board[3 * index]
      end
    end
    #Diagonals. These are explicit. There are only two diagonals on a 3x3 board. If the board size wasn't fixed, this would be an iterator as well.
    if @current_game_board[0] == @current_game_board[4] and @current_game_board[0] == @current_game_board[8] and not @current_game_board[0].nil?
      @winner['winner'], @winner['mark'] = @player[0], @current_game_board[0]
    elsif @current_game_board[6] == @current_game_board[4] and @current_game_board[6] == @current_game_board[2] and not @current_game_board[6].nil?
      @winner['winner'], @winner['mark'] = @player[0], @current_game_board[6]
    end
  end
  
  def newGame
    # Reset the state of the game, and save the current game and winner to the history.
    @history << { 
      'board' => @current_game_board,
      'winner' => @winner.clone 
    }
    @current_game_board = GameBoard.new
    @winner = nil
    @turn = 1
    
  end
end

class TicTacToeStrategy
  # Only for use with NoughtsAndCrosses game. Do not use with GlobalThermonuclearWar.
  # 2-9-1972, 14:55, <v.Chernobrov> Time machine project retrieved vital American plans from future for perfect Tic-Tac-Toe strategy.
  # 4-8-1982, 09:23, <g.Adelson-Velsky> I just looked this over. Tic-Tac-Toe is what Americans call Noughts and Crosses. You're wasting your time loading it into Oko.
  # 6-23-1983, 03:02, <n.Brusentsov> I finished the implementation. Had a lot of time on my hands while waiting for satellite realignment.
  def initialize

  end

  def playRandomly(game)
    # Doesn't get much simpler than this!
    # TODO error handling for :inputerror. 
    catch :inputerror do
      game.play(rand(9))
    end
  end

end

class Player
  # I intend to hold some info about the player... like a name or something. Win/loss history maybe?
  def play(game, input)
    game.play(input)
  end
end

class AI
  #Class that will have some methods and stuff, planning ahead for a much more interesting AI character.
  # Might be good to make this a child of the Player class?
  # If more games are implemented, I'll want to have it load strategies dynamically. 
  def initialize
    @strategy = TicTacToeStrategy.new
  end
  def play(game)
    # Pass the game along... This method ought to work with any @strategy loaded.
    @strategy.playRandomly(game)

  end

end

def simpleDraw(board)
  # The collect method is used to find and replace in an array. In this case, find Nil, replace with " ". 
  clean_board = board.collect { |obj| obj.nil? ? " " : obj }
  3.times { |index|
    # Array[index, length]. It's a good thing. Spit this out thrice and it almost looks like a tic tac toe board!
    p clean_board[3 * index, 3]
  }
end

def testThis
  # Leftover stuff. I have the feeling that I'll be reusing this, so I stuffed it into a method.
  # Some of this will probably make it into the playNAC method.
  game_a = NoughtsAndCrosses.new
  game_b = NoughtsAndCrosses.new
  game_c = NoughtsAndCrosses.new
  test_games = []
  test_games << game_a << game_b << game_c
  test_games.each { |game|
    while game.winner.nil?
      game.play(rand(9))
    end
  }
  test_games.each { |game|
    if game.winner == 'tie'
      puts "There was no winner this time. The state of the board was:"
      simpleDraw(game.board)
    else
      puts "The winner was " + game.winner + " and the state of the board was:"
      simpleDraw(game.board)
    end

  }
end

def playNAC
  # Pretty much the mainloop of the game.
  reference_board = (0..9).to_a # For player input.
  big_mac = AI.new  
  petrov = Player.new
  game = NoughtsAndCrosses.new(big_mac, petrov)
  while game.winner.nil?
    # Alright, so...
    # Who goes first?
    # Draw the game board.
    # Get some input, or do AI's turn.
    # Repeat
    # ...?
    # Profit!
    simpleDraw(game.board)
    
  end
end