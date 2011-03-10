# The game!

class GameBoard
  # Generic 2-d game board.
  # ALERT all code here should be agnostic to any rectangular board-based game.
  # @board keeps an array of the current state of the board.
  #TODO Implement 2-dimensional boards of variable dimension.
  attr_reader :array
  def initialize(array = [])
    # We allow a predefined board to be passed in as an array.
    @array = array
    # Because we'll soon need to address the array by position, I want to make sure it either has a complete board, or re-initialize it with 9 nil objects.
    if @array.nil? || @array.length != 9
      @array = Array.new(9)
    end
  end

  def [](index)
    # Fancy method! Allows you to treat any GameBoard object like an array and access the internal @array array.
    @array[index]
  end

  def mark(symbol, address)
    #Symbol is provided by the player. Presumably an X or O.
    #address is currently restricted to a single digit identifying a place on the array.
    if @array[address].nil?
      @array[address] = symbol
    else
      raise ArgumentError.new("Location is already marked.")
    end
  end

  def boardSlicer
    # boardSlicer ref: 0 = h1, 1 = h2, 2 = h3, 3 = v1, 4 = v2, 5 = v3, 6 = d\ 7 = d/
    return [
      @array[0, 3],
      @array[3, 3],
      @array[6, 3],
      [@array[0], @array[3], @array[6]],
      [@array[1], @array[4], @array[7]],
      [@array[2], @array[5], @array[8]],
      [@array[0], @array[4], @array[8]],
      [@array[6], @array[4], @array[2]]
    ]
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
    @board = GameBoard.new
    @winner = nil
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
      @turn % 2 == 0 ? @board.mark('O', address) : @board.mark('X', address)
      # Just marked up the board. Set the winner (returns nil if no winner)
      @winner = checkWinner
      # That's one turn. Turn counter + 1.
      @turn += 1
      # Finally, if we just finished the 9th turn, then @turn will be 10.
      # Therefore, there are no more moves left. Check to see if @winner is still nil.
      # If both are true, then that's it. Set winner to a tie game.
      @turn > 9 and @winner.nil? ? @winner = 'tie' : nil
    end
  end

  def checkWinner
    # This is way, way shorter than the old way.
    # But... I don't entirely agree with setting the @winner class attribute here.
    # This is much better. The method is  'checkWinner', not 'setWinner'
    @board.boardSlicer.each do |slice|
      if slice.uniq.length == 1  and slice.index(nil) == nil
        return currentPlayer
      end
    end
    return nil
  end

  def checkTie
    # @TODO Implement some method that checks for a tie game. Hopefully before the game is over.
  end

  def newGame
    # Reset the state of the game, and save the current game and winner to the history.
    @history << {
      'board' => @board,
      'winner' => @winner.clone
    }
    @board = GameBoard.new
    @winner = nil
    @turn = 1
    @player1, @player2 = @player2, @player1
    @player1[1] = 'X'
    @player2[1] = 'O'
    @players = [@player1, @player2]

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

  def simpleDraw()
    # The collect method is used to find and replace in an array. In this case, find Nil, replace with " ".
    clean_board_array = @board.array.collect { |obj| obj.nil? ? " " : obj }
    print "   A  B  C\n"
    3.times { |index|
      row = index + 1
      print row.to_s + " "
      # Array[index, length]. It's a good thing. Spit this out thrice and it almost looks like a tic tac toe board!
      clean_board_array[3 * index, 3].each do |cell|
        print "[" + cell + "]"
      end
      print "\n"
    }
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
    board_slices = game.board.boardSlicer
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
    board_slices = game.board.boardSlicer
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
    # There are exactly two fork defense scenarios for player 2.
    # X has always taken a center and a corner when preparing to fork.
    # One: X marked a corner. You took center. X is in opposite corner.You must play a side to prevent the fork.
    # Two: X marked the center. You took a corner. You must play a corner to prevent the fork.
    board_slices = game.board.boardSlicer
    # winslicer ref: 0 = h1, 1 = h2, 2 = h3, 3 = v1, 4 = v2, 5 = v3, 6 = d\ 7 = d/
    if board_slices[6].compact.length == 3 or board_slices[7].compact.length == 3
      case game.board.array.index(mark) #I thought this would be confusing, but it reads well! "Game Board Array Index"
      when 4 then return playEmptySide(game, mark)
      else return playEmptyCorner(game, mark)
      end
    else return nil
    end
  end

  def forkYou(game, mark)
    # See what I did there?
    if game.turn == 3
      case game.board.array.index(mark)
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
    opponent_in_corner = game.board.array.index(opponent_mark)
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

  def alphaBeta(node, depth, a, b, players, max_player)
    # implementation of alpha-beta minmax tree searching based on
    # http://en.wikipedia.org/wiki/Alpha-beta_pruning
    # node = a given state of the game board
    # depth = How far ahead to look. 9 is a full game.
    # a = Alpha
    # b = Beta
    # players = an array with [0] being the maximizing (current) player and [1] being the minimizing (opponent) player.
    # max_player = The Maximizing player, the original caller of the function.
    result = 0
    terminal = true if not node.board.array.index(nil) or not node.winner.nil?

    if depth == 0 or terminal
      # Because with all the deep cloning the node's player objects are all hoplessly irreconcilable with the players array we have...
      # We need to grab the right one by searching. Name isn't the best way, but there's little else to go on.
      node.players.each do |match_player|
        if match_player[0].name == players[0].name
          return evaluate_node(node, match_player[0])
        end
      end
    end
    if players[0].name == max_player.name
      node.board.array.each_index do |index|
        if node.board.array[index] == nil
          child = Marshal::load(Marshal.dump(node))
          players[0].play(child, child.convertCoord(index))
          a = [a, alphaBeta(child, depth - 1, a, b, players.reverse, max_player)].max
          break if b <= a
          result = a
        end
      end
    else
      node.board.array.each_index do |index|
        if node.board.array[index] == nil
          child = Marshal::load(Marshal.dump(node))
          players[1].play(child, child.convertCoord(index))
          b = [b, alphaBeta(child, depth - 1, a, b, players.reverse, max_player)].min
          break if b <= a
          result = b
        end
      end
    end
    return result
  end

  def evaluate_node(node, player)
    # The result of this is a float indicating the value of the current node to the given player.
    # node = A full NAC game object.
    # player = The player object for whom the evaluation is being done.
    # Ruby doesn't recognize that infinity < infinity + 1. We substitute 1 million.
    infinity = 1000000
    # The strategy functions need a 'mark' to base their decisions on.
    # We get this mark by flattening the 'players' array and then adding 1 to the index of the matching player object.
    # This works because flattened the array reads [player1, "X", player2, "O"]
    current_player_mark = node.players.flatten[node.players.flatten.index(player) + 1]
    # And the opposing player mark...
    current_player_mark == 'X' ? opposing_player_mark = 'O' : opposing_player_mark = 'X'
    # This is starting to look like a runaway conditional...
    if node.winner == player
      return infinity
    elsif node.winner != 'tie' and node.winner != nil
      return -infinity
    end
    heuristic_value = 0
    current_player_value = 1
    opposing_player_value = -1

    # The slices represent every winning line.
    # If you remove nil elements and non-unique elements, and it matches the player's mark,
    # and its compacted length is 2, then that tells us that not only does the player
    # have two marks on that line, but that there's also an empty space.
    node.board.boardSlicer.each do |slice|
      if slice.compact.length == 2 and slice.compact.uniq == [current_player_mark]
        heuristic_value += current_player_value
      elsif slice.compact.length == 2 and slice.compact.uniq == [opposing_player_mark]
        heuristic_value += opposing_player_value
      end
    end
    return heuristic_value

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