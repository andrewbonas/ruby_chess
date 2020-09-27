require_relative '../lib/tokens.rb'
require_relative '../lib/board.rb'

RSpec.describe Tokens do
  describe '#legal_move?' do
    before do
      display = Board.new
      @board = display.updated_board 
    end
    it 'returns true when moving white pawn 2 squares on first move' do
      expect(Tokens.legal_move?([6,0],[4,0],"\u2659", @board)).to be true
    end
    it 'returns false when moving white pawn 3 squares' do
      expect(Tokens.legal_move?([6,0],[3,0],"\u2659", @board)).to be false
    end
    it 'returns true when moving black pawn 1 square on first move' do
      expect(Tokens.legal_move?([1,0],[2,0],"\u265F", @board)).to be true
    end
  end

  describe '#clear_path' do
    before do
      display = Board.new
      @board = display.updated_board 
   end
    it 'returns false when moving a white rook over a white pawn' do
      expect(Tokens.clear_path([[7,0],[5,0]], @board, "\u2656")).to be false
    end
    it 'returns true when moving a white knight over a white pawn' do
      expect(Tokens.clear_path([[7,1],[5,3]], @board, "\u2658")).to be true
    end
    it 'returns false when moving black rook over a black pawn' do
      expect(Tokens.clear_path([[0,0],[4,0]], @board, "\u265C")).to be false
    end
  end
end
