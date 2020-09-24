class Pawn 
  def initialize(color)
    @color = color
    @symbols = symbols
  end

  OPTIONS_BLACK = [[1, 0]].freeze
  BLACK_ATTACK = [[1, -1], [1, 1]].freeze
  FIRST_MOVE_BLACK = [[2, 0], [1, 0]].freeze
  OPTIONS_WHITE = [[-1, 0]].freeze
  FIRST_MOVE_WHITE = [[-2, 0], [-1, 0]].freeze
  WHITE_ATTACK = [[-1, -1], [-1, 1]].freeze
  
  def symbols
    if @color == "black"
      @pawn_symbol = "\u265F"
    elsif @color == "white"
      @pawn_symbol = "\u2659"
    end
  end

  def to_s
    @pawn_symbol
  end
end