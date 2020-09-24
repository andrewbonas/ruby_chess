class King
  def initialize(color)
    @color = color
    @symbols = symbols
  end

  OPTIONS = [[0, 1], [0, -1], [1, 0], [-1, 0], [-1, -1], [1, 1], [-1, 1], [1, -1]].freeze

  def symbols
    if @color == "black"
      @king_symbol = "\u265A"
    elsif @color == "white"
      @king_symbol = "\u2654"
    end
  end

  def to_s
    @king_symbol
  end
end