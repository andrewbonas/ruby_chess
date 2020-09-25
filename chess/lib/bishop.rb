class Bishop
  def initialize(color)
    @color = color
    @symbols = symbols
  end

  OPTIONS = [[-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
    [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
    [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
    [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7,-7]].freeze

  def symbols
    if @color == "black"
      @bishop_symbol =  "\u265D"
    elsif @color == "white"
      @bishop_symbol = "\u2657"
    end
  end

  def to_s
    @bishop_symbol
  end
end
