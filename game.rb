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

  def [](index)
    @board[index]
  end

  def mark(symbol, address)
    #Symbol is provided by the player. Presumably an X or O.
    #address is currently restricted to a single digit identifying a place on the array.
    if @board[address].nil?
      @board[address] = symbol
    else
      throw :inputerror
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
  attr_reader :winner, :board
  def initialize()
    @current_game_board = GameBoard.new
    @winner = @current_game_board.winner
    @board = @current_game_board.board
    @player1 = 'X'
    @player2 = 'O'
    @players = [@player1, @player2]
    @current_player = 0 #0-index. 0 is 1, 1 is 2.
    @turn = 1
  end

  def mark(address)
    if @winner.nil? && @turn <= 9
      @current_game_board.mark(@players[@current_player], address)
      @turn += 1
      checkWinner
      @current_player == 0 ? @current_player = 1 : @current_player = 0
      @turn > 9 and @winner.nil? ? @winner = 'tie' : nil
    elsif @turn > 9 || @winner == 'tie'
      #raise "Game ended in a Tie.\nStart a new game."
    else
      #raise "Game has been won by " + @winner + "\nStart a new game."
    end
  end

  def checkWinner
    # A simple iterator/index with If statements. This is not much shorter than an explicit test for all 6 row/columns.
    #Columns and rows
    (0..2).each do |index|
      #columns
      if @current_game_board[index] == @current_game_board[index+3] and @current_game_board[index] == @current_game_board[index + 6] and not @current_game_board[index].nil?
        #All that matters is we identify the symbol we're testing for concurrence in a row or column.
        @winner = @current_game_board[index]
        puts "vert" + index.to_s
      end
      #rows
      if @current_game_board[3 * index] == @current_game_board[(3 * index) + 1] and @current_game_board[3 * index] == @current_game_board[(3 * index) + 2] and not @current_game_board[3 * index].nil?
        @winner = @current_game_board[3 * index]
        puts "horiz" + index.to_s
      end
    end
    #Diagonals. These are explicit. There are only two diagonals on a 3x3 board. If the board size wasn't fixed, this would be an iterator as well.
    if @current_game_board[0] == @current_game_board[4] and @current_game_board[0] == @current_game_board[8] and not @current_game_board[0].nil?
      @winner = @current_game_board[0]
      puts "diag1"
    elsif @current_game_board[6] == @current_game_board[4] and @current_game_board[6] == @current_game_board[2] and not @current_game_board[6].nil?
      @winner = @current_game_board[6]
      puts "diag2"
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

  def playRandomly(game)
    catch :inputerror do
      game.mark(rand(9))
    end
  end

end

class AI
  #Class that will have some methods and stuff, planning ahead for a much more interesting AI character.
  def initialize
    @strategy = TicTacToeStrategy.new
  end
  def play(game)
    @strategy.playRandomly(game)

  end

end

def simpleDraw(board)
  clean_board = board.collect { |obj| obj.nil? ? " " : obj }
  3.times { |index|
    p clean_board[3 * index, 3]
  }
end

def testThis
  game_a = NoughtsAndCrosses.new
  game_b = NoughtsAndCrosses.new
  game_c = NoughtsAndCrosses.new
  test_games = []
  test_games << game_a << game_b << game_c
  test_games.each { |game|
    while game.winner.nil?
      game.mark(rand(9))
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