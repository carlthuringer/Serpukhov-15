# UNIT TESTS TRANSFORM AND ROLL OUT
require 'test/unit'
require 'nac'

class TestNoughtsAndCrosses < Test::Unit::TestCase
  def test_checkWinner_winner
    # Pretty much have to set up and play a whole game. Then see that it reports the right person.
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    p1.play(game, "A1")
    p2.play(game, "B2")
    p1.play(game, "A2")
    p2.play(game, "A3")
    p1.play(game, "B1")
    p2.play(game, "C1")
    assert_equal(p1, game.checkWinner) # Game turn will be off by one. So if this works the other player is returned.
  end

  def test_checkWinner_tie
    # Pretty much have to set up and play a whole game. Then see that it reports the right person.
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    p1.play(game, "A1")
    p2.play(game, "A3")
    p1.play(game, "A2")
    p2.play(game, "B1")
    p1.play(game, "B3")
    p2.play(game, "B2")
    p1.play(game, "C1")
    p2.play(game, "C3")
    p1.play(game, "C2")
    assert_equal(nil, game.checkWinner) # Game turn will be off by one. So if this works the other player is returned.
  end
end

class TestGameBoard < Test::Unit::TestCase
  def test_boardSlicer
    board = [
      "X", "O", "O",
      "O", "X", "O",
      "O", "X", "O"]
    sliced = [
      ["X", "O", "O"],
      ["O", "X", "O"],
      ["O", "X", "O"],
      ["X", "O", "O"],
      ["O", "X", "X"],
      ["O", "O", "O"],
      ["X", "X", "O"],
      ["O", "X", "O"]
    ]

    board = GameBoard.new(board)
    assert_equal(sliced, board.boardSlicer)
  end
end

class TestTicTacToeStrategy < Test::Unit::TestCase
  def test_alphaBeta
    #
  end

  def test_evaluate_node_winLose
    # Test node evaluation. A winning board should return +infinity, a losing -infinity
    win = 100
    lose = -win
    strategy = TicTacToeStrategy.new
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    # A game in which p2 wins.
    p1.play(game, "A1")
    p2.play(game, "B2")
    p1.play(game, "A2")
    p2.play(game, "A3")
    p1.play(game, "B1")
    p2.play(game, "C1")

    assert_equal(win, strategy.evaluate_node(game, p2))
    assert_equal(lose, strategy.evaluate_node(game, p1))

  end

  def test_evaluate_node_tie
    # Test node evaluation. If the game has ended in a tie, the heuristic value is 0.
    strategy = TicTacToeStrategy.new
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    # A game in which nobody wins.
    p1.play(game, "A1")
    p2.play(game, "B2")
    p1.play(game, "B1")
    p2.play(game, "C1")
    p1.play(game, "A3")
    p2.play(game, "A2")
    p1.play(game, "C2")
    p2.play(game, "B3")
    p1.play(game, "C3")
    assert_equal(0, strategy.evaluate_node(game, p1))
  end

  def test_evaluate_node_scoring
    # Test the scoring of nodes. +1 for a state where there is one possible win, +2 for a fork negative for opponent's chances.
    strategy = TicTacToeStrategy.new
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    # A game in which Player 1 has a chance to win.
    p1.play(game, "B2")
    p2.play(game, "C2")
    p1.play(game, "A3")
    assert_equal(55, strategy.evaluate_node(game, p1))
    assert_equal(-45, strategy.evaluate_node(game, p2))
    # A little further and we set up a fork...
    p2.play(game, "C1")
    p1.play(game, "C3")
    assert_equal(110, strategy.evaluate_node(game, p1))
    assert_equal(-90, strategy.evaluate_node(game, p2))

  end

  def test_alphaBeta
    # Test the alpha-beta pruning algorithm to see that it chooses correctly the next move.
    # Given a game where X has taken centar and corner, and O corner and adjacent side.
    # X Should block O to prevent a win by O and also to create a fork opportunity.
    strategy = TicTacToeStrategy.new
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    # A game in which Player 1 has a chance to fork and must block Player 2.
    p1.play(game, "B2")
    p2.play(game, "A1")
    p1.play(game, "C3")
    p2.play(game, "A2")
    results = Array.new(9)
    infinity = 1000000

    game.board.array.each_index do |index|
      if game.board.array[index] == nil
        node = Marshal::load(Marshal.dump(game))
        node.play(index)
        results[index] = strategy.alphaBeta(node, 5 , -infinity, infinity, true)
      end
    end
    assert_equal("A3", game.convertCoord(results.index(results.compact.max)))
  end

  def test_play_alphaBeta
    # We need to see that the alphaBeta algorithm can play through several games
    # intelligently. So we will play 3 games against it. One in which it should fork and win.
    # One in which it should block the opponent's fork.
    # One in which it plays against an opponent that prevents its fork and ends in a tie.
    strategy = TicTacToeStrategy.new
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    strategy.play_alphaBeta(game, p1)
    game.simpleDraw
    #p2.play(game, "A1")
    #strategy.play_alphaBeta(game, p1)
    # game.simpleDraw
    assert_equal(p1, game.winner)
  end

  def test_depth_alphaBeta
    strategy = TicTacToeStrategy.new
    p1 = Player.new("Scott")
    p2 = Player.new("Casey")
    game = NoughtsAndCrosses.new(p1, p2)
    infinity = 1000000
    9.times do |depth|
      results = []
      game.board.array.each_index do |index|
        if game.board.array[index] == nil
          node = Marshal::load(Marshal.dump(game))
          node.play(index)
          results[index] = strategy.alphaBeta(node, depth, -infinity, infinity, true)
        end
      end
      p depth, results
    end
  end

end
