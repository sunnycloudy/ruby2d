# Morpion
# By Darkleo

$:.insert 0, '../../lib/'
require 'ruby2D'
include Ruby2D

Cache.add_location 'Morpion/'
Size = 85
class Move
  @@board = [nil]*9
  X = Bitmap.new ?X
  O = Bitmap.new ?O
  attr_reader :win_move, :valid, :x, :y
  def initialize x, y, c
    @valid = @@board[x + 3*y].nil?
    return unless @valid
    @x, @y = x, y
    @sprite = Sprite.new
    @sprite.x = Size*x
    @sprite.y = Size*y
    @sprite.bitmap = c == :x ? X : O
    @@board[x + 3*y] = c
    @win_move = win? c
    true
  end
  def dispose
    @sprite.dispose
    @@board[@x+3*@y] = nil
  end
  def win? c
    3.times {|k| return true if [@@board[k], @@board[k+3], @@board[k+6]] == [c]*3}
    3.times {|k| return true if [@@board[3*k], @@board[3*k+1], @@board[3*k+2]] == [c]*3}
    return true if [@@board[0], @@board[4], @@board[8]] == [c]*3
    return true if [@@board[2], @@board[4], @@board[6]] == [c]*3
    return false
  end
end

Window.name = 'Morpion'
Window.resize 3*Size, 3*Size
Window.run do
  @back = Sprite.new
  @back.bitmap = Bitmap.new 'back'
  @moves = []
  loop do
    Graphics.update
    Mouse.update
    if Mouse.trigger? Mouse::Left
      c = @moves.size % 2 == 0 ? :x : :o
      m = Move.new(Mouse.x/Size, Mouse.y/Size, c)
      next unless m.valid
      @moves << m
      break if m.win_move
    end
    break if @moves.size == 9
  end
  if @moves.last.win_move
    @back.bitmap = Bitmap.new('win')
    c = @moves.size % 2 == 0 ? :o : :x
    @moves.each &:dispose
    @winmove = Move.new(1, 0.5, c)
  else
    @back.bitmap = Bitmap.new('lose')
    @moves.each &:dispose
  end
  Graphics.update
  loop do
    Mouse.update
    exit! if Mouse.trigger? Mouse::Left
  end
end