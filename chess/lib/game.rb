require 'colorize'
require_relative "pawn.rb"
require_relative "bishop.rb"
require_relative "king.rb"
require_relative "knight.rb"
require_relative "queen.rb"
require_relative "rook.rb"
require_relative "board.rb"
require_relative "tokens.rb"

class Game

    def initialize
      @board = Board.new
      @tokens = Tokens.new
      @game = game

    end

    def intro
      puts "Welcome to command line Chess!"
      puts
      puts "Press enter to continue"
      gets.chomp
      puts "Two players are required to play"
      gets.chomp
      puts "White will go first (outlined pieces)"
      gets.chomp
      puts "Type S or L to save/load game at anypoint"
      gets.chomp
      puts "To move the chess pieces use algebraic notation"
      gets.chomp
      puts "Example: a2 a4"
      gets.chomp
    end

    def game
      @board.display_board
      round = 0
      #intro
      #@board.display_board
      loop do
        @board.insert_token(round)
        @board.display_board
        break  check_mate_message(round) if @board.check_mate?
        break puts "Draw" if @board.stale_mate?(round) || round == 49
        round +=1
        end
      end

  def check_mate_message(round)
    if (round % 2).zero? && @board.check_mate?
      puts 'Check Mate! White wins.'
    elsif @board.check_mate?
      puts 'Check Mate! Black wins.'
    end
  end
end


Game.new