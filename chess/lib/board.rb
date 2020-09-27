require_relative 'pawn.rb'
require_relative 'bishop.rb'
require_relative 'king.rb'
require_relative 'knight.rb'
require_relative 'queen.rb'
require_relative 'rook.rb'
require 'colorize'
require 'matrix'

class Board
  def  initialize
    @create_board = create_board
    @add_white_tokens = add_white_tokens
    @add_black_tokens = add_black_tokens
    @captures = captures
    @previous_move = previous_move
  end

  def create_board
    @board = []
    @columns = 8
    8.times do |row|
      @board[row] = []
      @columns.times do
        @board[row] << ' '
      end
    @board
    end
  end

  def display_board
    n = 8
    print "  #{@black_token_captures.join(' ')}" if @black_token_captures != nil
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
    puts '   a  b  c  d  e  f  g  h'
    print "  #{@white_token_captures.join(' ')}" if @white_token_captures != nil
    puts
  end

  def add_white_tokens
    8.times { |i| @board[6][i] = Pawn.new('white').to_s}
    @board[7][0] = Rook.new('white').to_s
    @board[7][1] = Knight.new('white').to_s
    @board[7][2] = Bishop.new('white').to_s
    @board[7][3] = Queen.new('white').to_s
    @board[7][4] = King.new('white').to_s
    @board[7][5] = Bishop.new('white').to_s
    @board[7][6] = Knight.new('white').to_s
    @board[7][7] = Rook.new('white').to_s
  end

  def add_black_tokens
    8.times { |i| @board[1][i] = Pawn.new('black').to_s}
    @board[0][0] = Rook.new('black').to_s
    @board[0][1] = Knight.new('black').to_s
    @board[0][2] = Bishop.new('black').to_s
    @board[0][3] = Queen.new('black').to_s
    @board[0][4] = King.new('black').to_s
    @board[0][5] = Bishop.new('black').to_s
    @board[0][6] = Knight.new('black').to_s
    @board[0][7] = Rook.new('black').to_s
  end

  def user_input
    loop do 
      print 'Type requested move: '
      @input = $stdin.gets.chomp.upcase
      if @input.length == 4
        @move = [[8-@input[1].to_i, @input[0].ord-65], [8-@input[-1].to_i, @input[-2].ord-65]]
      elsif @input == 'S'
        save_game?
        break
      elsif @input == 'D'
        puts 'Are you sure you want to call a Draw? (Type Y/N)'
        possible_draw = $stdin.gets.chomp.upcase
         if possible_draw == 'Y'
           puts 'Draw'
           exit
         end
      end
    break if valid_input?(@move)
    end
  end

  def save_game?
    if @input == 'S'
      true
    end
  end
  def updated_board
    @board
  end

  def insert_token(round)
    updated_board = @board
    check_message
    user_input
    move = @move
    token = @board[move[0][0]][move[0][1]]
    destination = @board[move[1][0]][move[1][1]]
      if @input == 'S'
        return
      elsif move_parameters_valid?(updated_board, move, token, round) && castling?(token, destination, move)
        return
      elsif move_parameters_valid?(updated_board, move, token, round) && legal_move?(updated_board, move, token, destination)
        move(round,move,token)
      else
        puts 'Invalid move, try again.'
        insert_token(round)
      end
    pawn_promotion?
  end

  def check_message
    token = []
    if white_check?(token) || black_check?(token)
      puts 'Check!'
    end
  end

  def move(round,move,token)
    @board[move[1][0]][move[1][1]] = @board[move[0][0]][move[0][1]]
    @board[move[0][0]][move[0][1]] = ' '
    if not_in_check(round,move,token)
      @last_move.push([move, token])
    else
      @board[move[0][0]][move[0][1]] = @board[move[1][0]][move[1][1]]
      @board[move[1][0]][move[1][1]] = ' '
      puts "Invalid move, try againr."
      insert_token(round)
    end
  end

  def previous_move
    @last_move = []
  end

  def able_en_passant(move, token)
    choices = []
    if @last_move != nil && @last_move.any?
      previous_move = @last_move.last.flatten()
      from = move[0]
      to = move[1]
      distance = previous_move[0] - previous_move[2]
      if (previous_move[4] == "\u265F" || previous_move[4] == "\u2659") && distance == 2
        if token == "\u2659" &&  move[1][0] == previous_move[2] - 1 && move[1][1] == previous_move[3]
          Pawn::WHITE_ATTACK.each do |x|
            choices << [x[0] + from[0], x[1] + from[1]]
          end
        elsif token == "\u265F" && move[1][0] == previous_move[2] + 1 && move[1][1] == previous_move[3]
          Pawn::BLACK_ATTACK.each do |x|
            choices << [x[0] + from[0], x[1] + from[1]]
          end
        end
      choices.include? to
      end
    end
  end

  def stale_mate?(round)
    if (round % 2).zero?
      @black_locations.all? do |item|
        stop_check_mate(item[0], item[1], @board) == false
      end
    else
      @white_locations.all? do |item|
        stop_check_mate(item[0], item[1], @board) == false
      end
    end
  end

  def check_mate?
    token = []
    if white_check?(token) == true
      @white_locations.all? do |item|
        stop_check_mate(item[0], item[1], @board) == false
      end
    elsif black_check?(token) == true
      @black_locations.all? do |item|
        stop_check_mate(item[0], item[1], @board) == false
      end
    end
  end

  private
  
  def stop_check_mate(from,token, updated_board)
    choices = []
    valid_choices = []
    stop_check = []
    Tokens.string_to_class(from,token, updated_board).each do |move|
      choices << [token, [move[0] + from[0], move[1] + from[1]], from]
    end
    choices.each do |n|
      if n[1][0].between?(0,7) && n[1][1].between?(0,7) && n.kind_of?(Array)  &&
        simulated_valid_attack?(n[0], @board[n[1][0]][n[1][1]], [n[2],n[1]])
        if Tokens.clear_path([n[2],n[1]], @board ,n[0])
          valid_choices << n
        end
      end 
    end
    clone_board = @board.map(&:clone)
      valid_choices.each do |n|
        token_color(n[0])
        clone_board[n[1][0]][n[1][1]] = clone_board[n[2][0]][n[2][1]]
        clone_board[n[2][0]][n[2][1]] = ' '
        if n[0] == @token_white.join() && white_check?(n[0], n[1]) == false
          stop_check << true
        elsif n[0] == @token_black.join() && black_check?(n[0], n[1]) == false
          stop_check << true
        end
        clone_board[n[2][0]][n[2][1]] = clone_board[n[1][0]][n[1][1]]
        clone_board[n[1][0]][n[1][1]] = ' '
      end
    stop_check.any? {|n| n == true}
  end

  def white_check?(*token, destination)
    white_king = "\u2654"
    if token.join() == white_king
      white_king_location = destination
    else
      white_king_location = Matrix[*@board].index(white_king)
    end
    black_locations = []
    @white_locations = []
    8.times do |x|
      8.times do |y|
        token_color(@board[x][y])
        if @board[x][y] != " " && @board[x][y] != @token_white.join()
          black_locations << [[x,y], @board[x][y]]
        elsif @board[x][y] != " " && @board[x][y] == @token_white.join()
          @white_locations << [[x,y], @board[x][y]]
        end
      end
    end
    black_locations.any? do |item|
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
    @black_locations = []
    white_locations = []
    8.times do |x|
      8.times do |y|
        token_color(@board[x][y])
        if @board[x][y] != " " && @board[x][y] != @token_black.join()
          white_locations << [[x,y], @board[x][y]]
        elsif @board[x][y] != " " && @board[x][y] == @token_black.join()
          @black_locations << [[x,y], @board[x][y]]
        end
      end
    end
    white_locations.any? do |item|
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
    if pieces.include?("\u2654") && pieces.include?("\u2656") && castling_directions(move) && white_check?(token) == false
      color = "white"
      direction = castling_directions(move)
      castling_move(color,direction)
    elsif pieces.include?("\u265A") && pieces.include?("\u265C") && castling_directions(move) && black_check?(token) == false
      color = "black"
      direction = castling_directions(move)
      castling_move(color,direction)
    end
  end

  def castling_directions(move)
    if move.eql?([[7, 4],[7, 7]]) || move.eql?([[7,7],[7,4]])
      'short' 
    elsif move.eql?([[7,0],[7,4]]) || move.eql?([[7,4],[7,0]])
      'long'
    elsif  move.eql?([[0,7],[0,4]]) || move.eql?([[0,4],[0,7]])
      'short'
    elsif move.eql?([[0,0],[0,4]]) || move.eql?([[0,4],[0,0]])
      'long'
    end
  end

  def move_parameters_valid?(updated_board, move, token, round)
    valid_input?(move) && Tokens.clear_path(move, updated_board, token) && Tokens.players_turn?(token, round)
  end

  def legal_move?(updated_board, move, token, destination)
    attack?(updated_board, move, token, destination) && 
      (able_en_passant(move, token) || Tokens.legal_move?(move.first, move.last, token, updated_board))
  end

  def attack?(updated_board, move, token, destination)
    if updated_board[move[1][0]][move[1][1]] != ' ' || able_en_passant(move, token)
      valid_attack?(token, destination, move)
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
    if token.ord.to_s(16).each_char.any?{ |char| lowercase.cover?(char) || uppercase.cover?(char) }
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

  def simulated_valid_attack?(token, destination, move)
    if @board[move[1][0]][move[1][1]] != ' ' || able_en_passant(move, token)
      if Tokens::BLACK.any? {|item| item == token} && Tokens::WHITE.any? {|item| item == destination}
        true
      elsif Tokens::WHITE.any? {|item| item == token} && Tokens::BLACK.any? {|item| item == destination}
        true
      elsif able_en_passant(move,token) && token == "\u2659" && destination == ' '
        true
      elsif able_en_passant(move,token) && token == "\u265F" && destination == ' '
        true
      end
    else
      true
    end
  end

  def valid_attack?(token, destination, move)
    token_color(token,destination)
    if !@token_black.empty? && !@destination_white.empty? && destination != ' '
      @black_token_captures << destination
    elsif !@token_white.empty? && !@destination_black.empty? && destination != ' '
      @white_token_captures << destination
    elsif able_en_passant(move,token) && token == "\u2659" && destination == ' '
      @white_token_captures << @board[move[1][0] + 1][move[1][1]]
      @board[move[1][0] + 1][move[1][1]] = ' '
    elsif able_en_passant(move,token) && token == "\u265F" && destination == ' '
      @black_token_captures << @board[move[1][0] - 1][move[1][1]]
      @board[move[1][0] - 1][move[1][1]] = ' '
    end
  end

  def valid_input?(move)
    move != nil && move[0][0].between?(0,7) && move[0][1].between?(0,7) &&
    move[1][0].between?(0,7) && move[1][1].between?(0,7) && @board[move[0][0]][move[0][1]] != ' '
  end
end
