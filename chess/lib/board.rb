require 'colorize'
require_relative "pawn.rb"
require_relative "bishop.rb"
require_relative "king.rb"
require_relative "knight.rb"
require_relative "queen.rb"
require_relative "rook.rb"
require 'matrix'

class Board

  
  
  def  initialize
    @create_board = create_board
    @add_white_tokens = add_white_tokens
    @add_black_tokens = add_black_tokens
    @captures = captures
  end

  def create_board
    @board = []
    @columns = 8
    8.times do |row|
        @board[row] = []

    @columns.times do |column|
     @board[row] << " " 
    end
   @board
  end
end

  def display_board
    n = 8
    print "  #{@black_token_captures.join(" ")}" if @black_token_captures != nil
      @board.each_with_index do  |row,index|
         puts 
         print "#{n} "
        
      if index.even?
        row.each.with_index  do |value,index|
      if index.even?
        print " #{value} ".colorize(:background => :cyan)
      elsif index.odd?
        print " #{value} ".colorize(:background => :light_black)
        end
      end
      elsif index.odd?
        row.each.with_index  do |value,index|
      if index.even?
        print " #{value} ".colorize(:background => :light_black)
      elsif index.odd?
        print " #{value} ".colorize(:background => :cyan)
          end  
        end 
      end
      n -= 1
      end
    puts
    puts "   a  b  c  d  e  f  g  h"
    print "  #{@white_token_captures.join(" ")}" if @white_token_captures != nil
    puts
  end


  def add_white_tokens

    #8.times { |i| @board[6][i] = Pawn.new('white').to_s}
   
   # @board[7][0] = Rook.new('white').to_s
    #@board[7][1] = Knight.new('white').to_s
    #@board[7][2] = Bishop.new('white').to_s
    #@board[7][3] = Queen.new('white').to_s
    @board[2][7] = King.new('white').to_s
    #@board[7][5] = Bishop.new('white').to_s
    #@board[7][6] = Knight.new('white').to_s
    @board[1][5] = Rook.new('white').to_s
  end

  def add_black_tokens

   # 8.times { |i| @board[1][i] = Pawn.new('black').to_s}

    @board[6][6] = Rook.new('black').to_s
    #@board[0][1] = Knight.new('black').to_s
    #@board[1][6] = Bishop.new('black').to_s
    #@board[0][3] = Queen.new('black').to_s
    @board[0][7] = King.new('black').to_s
    #@board[0][5] = Bishop.new('black').to_s
    #@board[0][6] = Knight.new('black').to_s
    #@board[0][7] = Rook.new('black').to_s
  end

  def insert_token(round)
    updated_board = @board
    loop do 
    
    print 'Type requested move: '
    input = gets.chomp.upcase
    @move = [[8-input[1].to_i, input[0].ord-65], [8-input[-1].to_i, input[-2].ord-65]]
     break if valid_input?(@move)
    end
    move = @move
    token = @board[move[0][0]][move[0][1]]
    destination = @board[move[1][0]][move[1][1]]

   if move_parameters_valid?(updated_board, move, token, round) && castling?(token, destination, move)
      return
   elsif move_parameters_valid?(updated_board, move, token, round) && legal_move?(updated_board, move, token, destination)
    move(round,move,token)
    else
      puts "Invalid move, try again."
      insert_token(round)
    end
   pawn_promotion?
  # check_mate(updated_board, move, token, round, destination)
  end

  
def move(round,move,token)
  @board[move[1][0]][move[1][1]] = @board[move[0][0]][move[0][1]]
  @board[move[0][0]][move[0][1]] = ' '
  if not_in_check(round,move,token)
  return
  else
    @board[move[0][0]][move[0][1]] = @board[move[1][0]][move[1][1]]
    @board[move[1][0]][move[1][1]] = ' '
    puts "You are in check, try again."
    insert_token(round)
  end
end

  def check_mate(updated_board, move, token, round, destination)
    p token 
    p destination
     King::OPTIONS.all? do |n|
      n
    end
  end

  def white_check?( *token, destination)
    white_king = "\u2654"
    
    if token.join() == white_king
      white_king_location = destination
    else
    white_king_location = Matrix[*@board].index(white_king)
    end
    token_locations = []

    8.times do |x|
      8.times do |y|
         token_color(@board[x][y])
        if @board[x][y] != " " && @board[x][y] != @token_white.join()
          token_locations << [[x,y], @board[x][y]]
        end
      end
    end
    token_locations.any? do |item|
      possible_check(item[0], white_king_location, item[1], @board)
    end
  end

  def black_check?(*token, destination)
    black_king = "\u265A"

    if token.join() == black_king
      black_king_location = destination
    else
      black_king_location = Matrix[*@board].index(black_king)
    end

    token_locations = []

    8.times do |x|
      8.times do |y|
        token_color(@board[x][y])
        if @board[x][y] != " " && @board[x][y] != @token_black.join()
          token_locations << [[x,y], @board[x][y]]
        end
      end
    end
    p token_locations
    token_locations.any? do |item|
    possible_check(item[0], black_king_location, item[1], @board)
    end
  end

  def possible_check(from,king,token, updated_board)
    choices = []
    Tokens.string_to_class(from,king,token, updated_board).each do |move|
      choices << [token, [move[0] + from[0], move[1] + from[1]], from]
    end
    
    choices.any? do |n|
      if n[1].eql? king 
       Tokens.clear_path([n[2],n[1]], @board ,n[0])
     end
    end
  end

  def not_in_check(round,move,token)
    destination = move[1]
      if (round % 2).zero?
        white_check?(token,destination) == false
      else
        black_check?(token,destination) == false
      end
  end

  def pawn_promotion?
    possible_white_pawns = []
    possible_black_pawns = []
   
    8.times { |i| possible_white_pawns << @board[0][i]}
    8.times { |i| possible_black_pawns << @board[7][i]}
    
    if  possible_white_pawns.include? "\u2659"
      square = possible_white_pawns.index("\u2659")
      white_pawn_promotion(square)
    elsif possible_white_pawns.include? "\u265F"
      square = possible_black_pawns.index("\u265F")
      black_pawn_promotion(square)
    end
  end

  def white_pawn_promotion(square)
    puts 'What would you like to promote your pawn to? '
    promotion = gets.chomp.upcase
     
    if promotion == 'QUEEN'
      @board[0][square] = Queen.new('white').to_s
    elsif promotion == 'ROOK'
      @board[0][square] = Rook.new('white').to_s
    elsif promotion == 'BISHOP'
      @board[0][square] = Bishop.new('white').to_s
    elsif promotion == 'KNIGHT'
      @board[0][square] = Knight.new('white').to_s
    end
  end

  def black_pawn_promotion(square)
    puts 'What would you like to promote your pawn to? '
    promotion = gets.chomp.upcase
    
    if promotion == 'QUEEN'
      @board[0][square] = Queen.new('black').to_s
    elsif promotion == 'ROOK'
      @board[0][square] = Rook.new('black').to_s
    elsif promotion == 'BISHOP'
      @board[0][square] = Bishop.new('black').to_s
    elsif promotion == 'KNIGHT'
      @board[0][square] = Knight.new('black').to_s
    end
  end

  def castling_move(color,direction)
    if color == 'white' && direction == 'short'
      @board[7][6] = @board[7][4] 
      @board[7][5] = @board[7][7]
      @board[7][4] = ' '
      @board[7][7] = ' '
    elsif color == 'white' && direction == 'long'
      @board[7][2] = @board[7][4] 
      @board[7][3] = @board[7][0]
      @board[7][4] = ' '
      @board[7][0] = ' '
    elsif color == 'black' && direction == 'short'
      @board[0][6] = @board[0][4] 
      @board[0][5] = @board[0][7]
      @board[0][4] = ' '
      @board[0][7] = ' '
    elsif color == 'black' && direction == 'long'
      @board[0][2] = @board[0][4] 
      @board[0][3] = @board[0][0]
      @board[0][4] = ' '
      @board[0][0] = ' '
    end
  end

  def castling?(token, destination, move)
    pieces = [token, destination]
    
    if pieces.include?("\u2654") && pieces.include?("\u2656") && castling_directions(move) && white_check? == false
      color = "white"
      direction = castling_directions(move)
      castling_move(color,direction)
    elsif pieces.include?("\u265A") && pieces.include?("\u265C") && castling_directions(move) && black_check? == false
      color = "black"
      direction = castling_directions(move)
      castling_move(color,direction)
    end
  end

  def castling_directions(move)
    if move.eql?([[7, 4],[7, 7]]) || move.eql?([[7,7],[7,4]])
      "short" 
    elsif move.eql?([[7,0],[7,4]]) || move.eql?([[7,4],[7,0]])
      "long"
    elsif  move.eql?([[0,7],[0,4]]) || move.eql?([[0,4],[0,7]])
      "short"
    elsif move.eql?([[0,0],[0,4]]) || move.eql?([[0,4],[0,0]])
      "long"
    end
  end
  
  def move_parameters_valid?(updated_board, move, token, round)
    valid_input?(move) && Tokens.clear_path(move, updated_board, token) && Tokens.players_turn?(token, round) 
  end

  def legal_move?(updated_board, move, token, destination)
    Tokens.legal_move?(move.first, move.last, token, updated_board) &&
    attack?(updated_board, move, token, destination)
  end

  def attack?(updated_board, move, token, destination)
    if updated_board[move[1][0]][move[1][1]] != ' ' 
      valid_attack?(token, destination)
    else 
      true
    end
  end

  def token_color(token, *destination)
    @token_white =[]
    @token_black = []
    @destination_black = []
    @destination_white = []
    lowercase = ('a'..'z')
    uppercase = ('A'..'Z')
    
    if  token.ord.to_s(16).each_char.any?{ |char| lowercase.cover?(char) || uppercase.cover?(char) }
      @token_black << token
    else
      @token_white << token
    end

    unless destination.empty?
      
    if destination.join().ord.to_s(16).each_char.any?{ |char| lowercase.cover?(char) || uppercase.cover?(char) }
      @destination_black << destination
    else 
      @destination_white << destination
    end
    end
  end

  def captures
    @white_token_captures = []
    @black_token_captures = []
  end

  def valid_attack?(token, destination)
    token_color(token,destination)
  
    if !@token_black.empty? && !@destination_white.empty?
      @black_token_captures << destination
      true
    elsif !@token_white.empty? && !@destination_black.empty?
      @white_token_captures << destination
      true
    else
      false
    end
  end

  def valid_input?(move)
   move[0][0].between?(0,7) && move[0][1].between?(0,7) && move[1][0].between?(0,7) && move[1][1].between?(0,7) && @board[move[0][0]][move[0][1]] != ' '
  end
end