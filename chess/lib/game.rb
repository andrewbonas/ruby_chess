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

    def initialize
      @board = Board.new
      @tokens = Tokens.new
      @round = round
      @intro = intro
      @game = game
    end

    def rules
      puts "Here are the rules"
      gets.chomp
      puts "Two players are required to play"
      gets.chomp
      puts "White will go first (outlined pieces)"
      gets.chomp
      puts "Type S to save game at anypoint"
      gets.chomp
      puts "To move the chess pieces use algebraic notation"
      gets.chomp
      puts "Example: a2 a4"
      gets.chomp
    end

    def intro
      puts "Welcome to command line Chess!"
      gets.chomp
      new_or_load
      @board.display_board
      rules
      game
    end

    def round
      @round = 0
    end

    def game
      @board.display_board
      loop do
        @board.insert_token(@round)
        break save_game_state if @board.save_game? == true
        @board.display_board
        break  check_mate_message(@round) if @board.check_mate?
        break puts "Draw" if @board.stale_mate?(@round) || @round == 49
        @round +=1
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

  def save_game_state

  Dir.mkdir("saves") unless Dir.exists? "saves"
    puts Dir.children("saves/")
    puts
    puts "Caution, if the filename already exists the file will be overwritten."
    print "Create filename to save "
    filename = gets.chomp.downcase

    yaml = YAML::dump(self)
    File.open("saves/#{filename}.yaml", "w+") {|x| x.write yaml}
    puts "Game saved"
    exit
  end

  def load_game
    puts
    filename = nil
    puts Dir.children("saves/")
    puts
    loop do 
     puts 'Please enter an existing filename from above (excluding .yaml):'
       filename = gets.chomp.downcase
       break if File.exists? "saves/#{filename}.yaml"
    end

    save_state = YAML.load_file("saves/#{filename}.yaml")
    puts "Welcome back, here is where you left off:"
    save_state.game
  end


Game.new


