# The game!

class GameBoard
  # Attributes.
  # board keeps an array of the current state of the board.
  # win_state stores the winner of the game.
  # turn is a counter for how many turns have been taken.
  # Interesting fact: Nowhere does the board become picky about what symbols are used with it. You can play Ys and Ps, Bs and Gs, or P, B & Js. :D
  attr_reader :board, :winner, :turn
  attr_writer :winner
  def initialize(board = [])
    @board = board #If you don't do this, the passed-in array doesn't become a class attribute. :(
    #Because we'll soon need to address the array by position, I want to make sure it either has a complete board, or re-initialize it with 9 nil objects.
    if @board.nil? || @board.length != 9
      @board = Array.new(9)
    end
  end

  def mark(symbol, address)
    #Symbol is provided by the player. Presumably an X or O.
    #address is currently restricted to a single digit identifying a place on the array.
    if @board[address].nil?
      @board[address] = symbol
    else
      raise ArgumentError, "Location is already marked."
    end
  end
end

class NoughtsAndCrosses
  # Noughts And Crosses
  # The generally English-European name for Tic-Tac-Toe.
  # The game has two players, two symbols (X and O), and is played on a 3x3 grid.
  # Players alternate symbols, with X going first. Each player makes a single mark in an unmarked space.
  # To achieve a win, a player must place the last symbol to form a row, column or diagonal of concurrent, identical symbols.
  # If neither player has achieved a win by the 9th turn, the game ends in a tie.
  def initialize()
    @current_game_board = GameBoard.new
    @player1 = 'X'
    @player2 = 'O'
    @players = [@player1, @player2]
    @current_player = 0 #0-index. 0 is 1, 1 is 2.
    @turn = 1
  end

  def mark(address)
    if @current_game_board.winner.nil? && @turn <= 9
      @current_game_board.mark(@players[@current_player], address)
      @turn += @turn
      checkWinner
      @current_player == 0 ? @current_player = 1 : @current_player = 0
    elsif @turn > 9 || @current_game_board.winner == 'tie'
      raise "Game ended in a Tie.\nStart a new game."
    else
      raise "Game has been won by " + @current_game_board.winner + "\nStart a new game."
    end
  end

  def checkWinner
    # A simple iterator/index with If statements. This is not much shorter than an explicit test for all 6 row/columns.
    #Columns and rows
    (0..2).each do |index|
      #columns
      if @current_game_board[index] == @current_game_board[index+3] && @current_game_board[index] == @current_game_board[index + 6]
        #All that matters is we identify the symbol we're testing for concurrence in a row or column.
        @current_game_board[index].nil? ? nil : @current_game_board.winner = @current_game_board[index]
      end
      #rows
      if @current_game_board[3 * index] == @current_game_board[(3 * index) + 1] && @current_game_board[3 * index] == @current_game_board[(3 * index) + 2]
        @current_game_board[3 * index].nil? ? nil : @current_game_board.winner = @current_game_board[3 * index]
      end
    end
    #Diagonals. These are explicit. There are only two diagonals on a 3x3 board. If the board size wasn't fixed, this would be an iterator as well.
    if @current_game_board[0] == @current_game_board[4] && @current_game_board[0] == @current_game_board[8]
      @current_game_board[0].nil? ? nil : @current_game_board.winner = @current_game_board[0]
    elsif @current_game_board[6] == @current_game_board[4] && @current_game_board[6] == @current_game_board[2]
      @current_game_board[6].nil? ? nil : @current_game_board.winner = @current_game_board[6]
    end
  end
end