class Rook
  def initialize(color)
    @color = color
    @symbols = symbols
  end

  OPTIONS = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
    [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
    [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
    [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]].freeze

  def symbols
    if @color == "black"
      @rook_symbol = "\u265C"
    elsif @color == "white"
      @rook_symbol = "\u2656"
    end
  end

  def to_s
    @rook_symbol
  end
end
