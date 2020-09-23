require 'colorize'
require_relative "pawn.rb"
require_relative "bishop.rb"
require_relative "king.rb"
require_relative "knight.rb"
require_relative "queen.rb"
require_relative "rook.rb"
require_relative "board.rb"
require_relative "tokens.rb"
require 'yaml'

class Game
attr_accessor :save_game
    def initialize
      @board = Board.new
      @tokens = Tokens.new
      @game = game
      @save_game = save_game
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
      new_or_load
      #intro
      #@board.display_board
      loop do
        @board.insert_token(round)
        break save_game if @board.save_game? == true
        @board.display_board
        break  check_mate_message(round) if @board.check_mate?
        break puts "Draw" if @board.stale_mate?(round) || round == 49
        round +=1
        end
      end
    end

  def check_mate_message(round)
    if (round % 2).zero? && @board.check_mate?
      puts 'Check Mate! White wins.'
    elsif @board.check_mate?
      puts 'Check Mate! Black wins.'
    end
  end
  
  def new_or_load
    puts "New game or Load game? (Type L or N)"
    if gets.chomp.upcase == 'L'
      load_game
    end
  end

  def self.save_game
    Dir.mkdir("saves") unless Dir.exists? "saves"
    print "Create filename to save: "
    filename = gets.chomp.lowercase

    yaml = YAML::dump(self)
    File.open("saves/#{filename}.yaml", "w+") {|x| x.write yaml}
    puts "Game saved"
    exit
  end

  def load_game
    filename = nil
    puts Dir.children("saves/")
    loop do 
     puts 'Please enter an existing filename (excluding .yaml):'
       filename = gets.chomp.lowercase
       break if File.exists? "saves/#{filename}.yaml"
    end

    save_state = YAML.load_file("saves/#{filename}.yaml")
    save_state.loaded_game
  end

  def loaded_game
    puts "Welcome back, here is where you left off: "
    game
  end


Game.new


