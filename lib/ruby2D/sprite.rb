class Sprite
  attr_reader :name, :id
  attr_accessor :x, :y, :z
  attr_accessor :ox, :oy, :angle
  attr_accessor :rect
  attr_accessor :zoom_x, :zoom_y
  attr_accessor :visible
  attr_reader :texture
  # Create a new Sprite object.
  #
  # args can be :
  # * (defaults arguments)
  # * texture
  # * a Hash with all or part of the args
  def initialize *args
    case args.size
    when 0 # Default
      @name = ''
      @x    = 0
      @y    = 0
      @z    = 0
      @ox   = 0
      @oy   = 0
      @angle   = 0
      @zoom_x  = 100
      @zoom_y  = 100
      @visible = true
      @texture = Texture.new
      @rect = Rect.new(0, 0, @texture.width, @texture.height)
    when 1
      case args[0]
      when Hash
        hash = args[0]
        @name = hash[:name]
        @x    = hash[:x]||0
        @y    = hash[:y]||0
        @z    = hash[:z]||0
        @ox   = hash[:ox]||0
        @oy   = hash[:oy]||0
        @angle   = hash[:angle]||0
        @zoom_x  = hash[:zoom_x]||hash[:zoom]||100
        @zoom_y  = hash[:zoom_y]||hash[:zoom]||100
        @visible = hash[:visible].nil? ? true : hash[:visible].nil?
        @texture = hash[:texture]||Texture.new
        @rect = hash[:rect]||Rect.new(0, 0, @texture.width, @texture.height)
      when Texture
        @name = ''
        @x    = 0
        @y    = 0
        @z    = 0
        @ox   = 0
        @oy   = 0
        @angle   = 0
        @zoom_x  = 100
        @zoom_y  = 100
        @visible = true
        @texture = args[0]
        @rect = Rect.new(0, 0, @texture.width, @texture.height)
      else
        fail 'Argument error in Sprite#initialize'
      end
    else
      fail 'Bad number of arguments in Sprite#initialize'
    end
    create_id
    Graphics.add self
    @deleted = false
  end
  def dispose
    Graphics.remove self
    @deleted = true
  end

  def <=> graph
    self.z <=> graph.z
  end
  def set_update &block
    @update_block = block
  end
  def update
    return if @deleted
    instance_eval &@update_block if @update_block
  end
  def update_texture
    return if @deleted
    @texture.update
  end
  
  def texture=tex
    return if @texture == tex
    @texture = tex
    @rect = Rect.new(0, 0, @texture.width, @texture.height)
  end

  def output # intern use ONLY
    return unless @texture
    return unless @visible

    GL.LoadIdentity
    GL.Translate(@x, -@y, 0)
    GL.Scale(@zoom_x/100.0, @zoom_y/100.0, 1)
    GL.Rotate(@angle, 0, 0, 1) if @angle != 0
    GL.Translate(-@ox, @oy, 0)

    @texture.use

    w = @rect.width
    h = @rect.height
    s = @texture.real_size.to_f
    c1, c2, c3, c4 = *@rect.coords.map {|t| [t[0]/s, t[1]/s]}

    GL.Begin(GL::QUADS)
    GL.TexCoord2f(*c1) ; GL.Vertex3f(0, 0, 0)
    GL.TexCoord2f(*c2) ; GL.Vertex3f(w, 0, 0)
    GL.TexCoord2f(*c3) ; GL.Vertex3f(w, -h, 0)
    GL.TexCoord2f(*c4) ; GL.Vertex3f(0, -h, 0)
    GL.End
  end

  private
  # TODO : change @@Max_IDS
  @@Max_IDS ||= 0
  def create_id
    @id = @@Max_IDS += 1
    @name ||= "Spr#{@id}"
  end
end