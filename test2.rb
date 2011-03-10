# @TODO merge with other test file when you get home.
require 'nac'
require 'test/unit'

class TestTicTacToeStrategy < Test::Unit::TestCase
  def test_alphaBeta
    #
  end

  def test_evaluate_node_winLose
    # Test node evaluation. A winning board should return +infinity, a losing -infinity
    infinity = (1.0/0.0)
    neg_infinity = (-1.0/0.0)

    strategy = TicTacToeStrategy.new
    board = [
      "X", "O", nil,
      "O", "X", nil,
      nil, nil, "X",
    ]
    assert_equal(infinity, strategy.evaluate_node(board, "X"))
    assert_equal(neg_infinity, strategy.evaluate_node(board, "O"))

  end
end

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
    game.simpleDraw
    p game.board.boardSlicer
    assert_equal(p1, game.winner)
    #assert_equal(p1, game.checkWinner)

  end
end