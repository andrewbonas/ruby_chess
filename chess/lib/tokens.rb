require_relative "board.rb"



class Tokens

  def initialize
  
  end

  def self.legal_move?(from,to,token, updated_board)
    choices =[]
    string_to_class(from,to,token, updated_board).each do |move|
    choices << [move[0] + from[0], move[1] + from[1]]
    end
    choices.include? to
  end

  def self.players_turn?(token, round)
    lowercase = ('a'..'z')
    uppercase = ('A'..'Z')

    if (round % 2).zero?
      token.ord.to_s(16).each_char.none?{ |char| lowercase.cover?(char) || uppercase.cover?(char) }
    else
      token.ord.to_s(16).each_char.any?{ |char| lowercase.cover?(char) || uppercase.cover?(char) }
    end
  end

  def self.string_to_class(from,to,token, updated_board)
    destination = updated_board[to[0]][to[1]]

    if  ["\u265E", "\u2658"].include?(token)
      Knight::OPTIONS
    elsif ["\u265F", "\u2659"].include?(token)
      pawn_options(token, from, destination)
    elsif ["\u265B", "\u2655"].include?(token)
      Queen::OPTIONS
    elsif ["\u265C", "\u2656"].include?(token)
      Rook::OPTIONS
    elsif ["\u265D", "\u2657"].include?(token)
      Bishop::OPTIONS
    elsif ["\u265A", "\u2654"].include?(token)
      King::OPTIONS
    end
  end
  
  def self.pawn_options(token, from, destination)
    orgin_row = from[0]
  if ["\u265F"].include?(token) && orgin_row == 1 && destination == ' '
    Pawn::FIRST_MOVE_BLACK
  elsif ["\u265F"].include?(token) && orgin_row != 1 && destination == ' '
    Pawn::OPTIONS_BLACK
  elsif ["\u265F"].include?(token) && destination != ' '
    Pawn::BLACK_ATTACK
  elsif ["\u2659"].include?(token) && orgin_row != 6 && destination == ' '
    Pawn::OPTIONS_WHITE
  elsif ["\u2659"].include?(token) && orgin_row == 6 && destination == ' '
    Pawn::FIRST_MOVE_WHITE
  elsif ["\u2659"].include?(token) && destination != ' '
    Pawn::WHITE_ATTACK
  end
  end

  def self.clear_path(move, updated_board, token)
    return true if token == "\u2658" || token == "\u265E"
    orgin_row = move[0][0]
    orgin_col = move[0][1]
    finish_row = move[1][0]
    finish_col = move[1][1]
    @mixed_moves = []
    @squares_passed = []
    @board = updated_board
    
    distance_moved(orgin_row, orgin_col, finish_row, finish_col)
    token_direction(orgin_row, orgin_col, finish_row, finish_col)
    tokens_blocking_way?
  end

  def self.distance_moved(orgin_row, orgin_col, finish_row, finish_col)
    @rows_moved = (orgin_row - finish_row).abs
    @cols_moved = (orgin_col - finish_col).abs

   if @rows_moved.zero?
     @rows_moved = @cols_moved
   elsif @cols_moved.zero?
     @cols_moved = @rows_moved
   end
  end

  def self.token_direction(orgin_row, orgin_col, finish_row, finish_col)

    if orgin_row > finish_row && orgin_col < finish_col
      token_north_east(orgin_row, orgin_col, finish_row, finish_col)
    elsif orgin_row > finish_row && orgin_col > finish_col
      token_north_west(orgin_row, orgin_col, finish_row, finish_col)
    elsif orgin_row < finish_row && orgin_col > finish_col
      token_south_west(orgin_row, orgin_col, finish_row, finish_col)
    elsif orgin_row < finish_row && orgin_col < finish_col
      token_south_east(orgin_row, orgin_col, finish_row, finish_col)
    elsif orgin_row > finish_row && orgin_col == finish_col
      token_north(orgin_row, orgin_col, finish_row, finish_col)
    elsif orgin_row < finish_row && orgin_col == finish_col
      token_south(orgin_row, orgin_col, finish_row, finish_col)
    elsif orgin_row == finish_row && orgin_col > finish_col 
      token_west(orgin_row, orgin_col, finish_row, finish_col)
    elsif orgin_row == finish_row && orgin_col < finish_col
      token_east(orgin_row, orgin_col, finish_row, finish_col)
    end
  end

  def self.token_north_east(orgin_row, orgin_col, finish_row, finish_col)
    # puts "North East"
    after_orgin_row = orgin_row - 1
    after_orgin_col = orgin_col + 1
      @rows_moved.times {|n| @mixed_moves << after_orgin_row - n}
      @cols_moved.times {|n| @mixed_moves << after_orgin_col + n}
    first_col = @mixed_moves.length / 2
    spaces_moved = first_col - 1
      spaces_moved.times {|n| @squares_passed << [(@mixed_moves[0 + n]), (@mixed_moves[first_col] + n)]}
    end
    
    def self.token_north_west(orgin_row, orgin_col, finish_row, finish_col)
      # puts "North West"
      after_orgin_row = orgin_row - 1
      after_orgin_col = orgin_col - 1 
        @rows_moved.times {|n| @mixed_moves << after_orgin_row - n}
        @cols_moved.times {|n| @mixed_moves << after_orgin_col - n}
      first_col = @mixed_moves.length / 2
      spaces_moved = first_col - 1
        spaces_moved.times {|n| @squares_passed << [(@mixed_moves[0 + n]), (@mixed_moves[first_col] + n)]}
    end

    def self.token_south_west(orgin_row, orgin_col, finish_row, finish_col)
      # puts "South West"
      after_orgin_row = orgin_row + 1
      after_orgin_col = orgin_col - 1 
        @rows_moved.times {|n| @mixed_moves << after_orgin_row + n}
        @cols_moved.times {|n| @mixed_moves << after_orgin_col - n}
      first_col = @mixed_moves.length / 2
      spaces_moved = first_col - 1
        spaces_moved.times {|n| @squares_passed << [(@mixed_moves[0 + n]), (@mixed_moves[first_col] - n)]}
    end

    def self.token_south_east(orgin_row, orgin_col, finish_row, finish_col)
      # puts "South East"
      after_orgin_row = orgin_row + 1
      after_orgin_col = orgin_col + 1
        @rows_moved.times {|n| @mixed_moves << after_orgin_row + n}
        @cols_moved.times {|n| @mixed_moves << after_orgin_col + n}
      first_col = @mixed_moves.length / 2
      spaces_moved = first_col - 1
        spaces_moved.times {|n| @squares_passed << [(@mixed_moves[0 + n]), (@mixed_moves[first_col] + n)]}
    end

    def self.token_north(orgin_row, orgin_col, finish_row, finish_col)
      # puts "North"
      after_orgin_row = orgin_row - 1
      after_orgin_col = orgin_col  
        @rows_moved.times {|n| @mixed_moves << (after_orgin_row - n).abs}
        @cols_moved.times {|n| @mixed_moves << after_orgin_col }
      first_col = @mixed_moves.length / 2
      spaces_moved = first_col - 1
        spaces_moved.times {|n| @squares_passed << [(@mixed_moves[0 + n]), (@mixed_moves[first_col])]}
    end

    def self.token_south(orgin_row, orgin_col, finish_row, finish_col)
      # puts "South"
      after_orgin_row = orgin_row + 1
      after_orgin_col = orgin_col  
        @rows_moved.times {|n| @mixed_moves << after_orgin_row + n}
        @cols_moved.times {|n| @mixed_moves << after_orgin_col }
      first_col = @mixed_moves.length / 2
      spaces_moved = first_col - 1
        spaces_moved.times {|n| @squares_passed << [(@mixed_moves[0 + n]), (@mixed_moves[first_col])]}
    end
  
    def self.token_west(orgin_row, orgin_col, finish_row, finish_col)
      # puts "West"
      after_orgin_row = orgin_row 
      after_orgin_col = orgin_col - 1
        @rows_moved.times {|n| @mixed_moves << after_orgin_row }
        @cols_moved.times {|n| @mixed_moves << after_orgin_col - n }
      first_col = @mixed_moves.length / 2
      spaces_moved = first_col - 1
        spaces_moved.times {|n| @squares_passed << [(@mixed_moves[0]), (@mixed_moves[first_col] - n)]}
    end

    def self.token_east(orgin_row, orgin_col, finish_row, finish_col)
     # puts "East"
      after_orgin_row = orgin_row 
      after_orgin_col = orgin_col + 1
        @rows_moved.times {|n| @mixed_moves << after_orgin_row }
        @cols_moved.times {|n| @mixed_moves << after_orgin_col + n }
      first_col = @mixed_moves.length / 2
      spaces_moved = first_col - 1
        spaces_moved.times {|n| @squares_passed << [(@mixed_moves[0]), (@mixed_moves[first_col] + n)]}
    end

  def self.tokens_blocking_way?
    @squares_passed.each do |n|
      row = n[0]
      col = n[1]
    break false if @board[row][col] != " " 
    end
  end

end
