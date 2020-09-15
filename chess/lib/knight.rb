require_relative "tokens.rb"


class Knight 
  def initialize(color)
    @color = color
    @symbols = symbols
  end

  OPTIONS = [[-2, 1], [-1, -2], [-2, -1], [1, -2], [1, 2], [2, 1], [-1, 2], [2, -1]].freeze

  def symbols
    if @color == 'black'
      @knight_symbol ="\u265E"
    elsif @color == 'white'
      @knight_symbol = "\u2658"
    end
  end

  def to_s
    @knight_symbol
  end
end


 