# Handles input data from a keyboard.
class Ruby2D::Input
  @current = {}
  @next    = {}
end
class << Ruby2D::Input
  # Updates input data.
  # 
  # As a rule, this method is called once per frame.
  def update
    for key in @current.keys | @next.keys
      if @next[key]
        case @next[key]
        when :press
          @current[key] = (@current[key]||1)+1
        when :trig
          @current[key] = (@current[key]||0)+1
        when :release
          @current[key] = -1
        end
      elsif @current[key] == -1
        @current.delete key
      else
        @current[key] += 1
      end
    end
    @next.clear
    nil
  end

  def feed(hash)
    @next.update hash
    nil
  end

  # Determines whether the button _key_ is being pressed again.
  #
  # "Pressed again" is seen as time having passed between the button being not pressed and being pressed.
  #
  # If the button is being pressed, returns +TRUE+.
  # If not, returns +FALSE+.
  def trigger? key
    state = @current[key.to_s]
    state ? state == 1 : false
  end

  # Determines whether the button _key_ is currently being pressed.
  #
  # If the button is being pressed, returns +TRUE+.
  # If not, returns +FALSE+.
  def press? key
    state = @current[key.to_s]
    state ? state > 0 : false
  end

  # Determines whether the button _key_ is currently being releassed.
  #
  # If the button is being released, returns +TRUE+.
  # If not, returns +FALSE+.
  def release? key
    state = @current[key.to_s]
    state ? state == -1 : false
  end

  # Determines whether the button _key_ is being pressed again.
  #
  # Unlike trigger?, takes into account the repeat input of a button being held down continuously.
  #
  # If the button is being pressed, returns +TRUE+.
  # If not, returns +FALSE+.
  def repeat? key
    state = @current[key.to_s]
    state ? (state > 8 and state%4 == 0) : false
  end

  # Checks the status of the directional buttons,
  # translates the data into a specialized 4-direction input format,
  # and returns the number pad equivalent (2, 4, 6, 8).
  #
  # If no directional buttons are being pressed (or the equivalent),
  # returns 0.
  def dir4
    (1..4).each {|i| return 2*i if press?((2*i).to_s)}
    0
  end

  # Checks the status of the directional buttons,
  # translates the data into a specialized 8-direction input format,
  # and returns the number pad equivalent (1, 2, 3, 4, 6, 7, 8, 9).
  #
  # If no directional buttons are being pressed (or the equivalent),
  # returns 0.
  def dir8
    (1..4).each {|i| return 2*i-1 if press?((2*i-1).to_s)}
    dir4
  end

  # Checks the status of the directional buttons,
  # translates the data into a specialized 9-direction input format,
  # and returns the number pad equivalent (1, 2, 3, 4, 5, 6, 7, 8, 9).
  #
  # If no directional buttons are being pressed (or the equivalent),
  # returns 0.
  def dir9
    (1..9).each {|i| return i if press? i.to_s}
    0
  end
end