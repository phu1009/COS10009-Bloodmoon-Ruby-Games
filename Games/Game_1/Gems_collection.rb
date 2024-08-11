require 'rubygems'
require "gosu"
require_relative './Rock'
require_relative './Buttons_click'

class GemsCollection < Gosu::Window
  attr_accessor :records

  def initialize(records)
    super(800, 600)
    self.caption = 'Gems Collection'

    # Set up variables for media (images, songs, sounds, fonts)
    @gemmining = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Gem_Mining.png')
    @question = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Question.png')
    @underground = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Underground.jpg')
    @easy_image = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Easy_Button.png')
    @hard_image = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Hard_Button.png')
    @image_mp_2 = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Mouse_pointer_2.png')
    @image_mp_3 = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Mouse_pointer_3.png')
    @emerald = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Emerald.png')
    @ruby = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Ruby.png')
    @sapphire = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Sapphire.png')
    @danburite = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Danburite.png')
    @amethyst = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Amethyst.png')
    @hammer = Gosu::Image.new('D:\COS10009\Custom Code\Media\Image_Hammer.png')
    @start_song = Gosu::Song.new('D:\COS10009\Custom Code\Media\Song_How_it_Begins.wav')
    @game_song_1 = Gosu::Song.new('D:\COS10009\Custom Code\Media\Song_Mining_by_Moonlight.wav')
    @game_song_2 = Gosu::Song.new('D:\COS10009\Custom Code\Media\Song_GD_The_seven_seas.wav')
    @end_song = Gosu::Song.new('D:\COS10009\Custom Code\Media\Song_Chill.wav')
    @collect_sound = Gosu::Sample.new('D:\COS10009\Custom Code\Media\Sound_Collecting.wav')
    @wrong_sound = Gosu::Sample.new('D:\COS10009\Custom Code\Media\Sound_Wrong.wav')
    @font = Gosu::Font.new(30)

    # Set up variables used for playing this game
    @x = Array.new(5, 400)
    @y = Array.new(5, 300)
    @vx = [1, 3, 5, 7, 15]
    @vy = [1, 3, 5, 7, 15]
    @visible = Array.new(5, 0)
    @rocks = []
    @screen = 0
    @level = 0
    @hit = @score = @start_time = 0
    @instruction_y = @instruction_y_index = 0

    # Set up variables for recording process
    @count_index = 0
    @records = records
  end

  def rocks_clicking(mouse_x, mouse_y) # Check if player clicked on rocks
    @rocks.any? { |rock| Gosu.distance(mouse_x, mouse_y, rock.x, rock.y) < (25 * rock.ratio) }
  end

  def needs_cursor?
    false
  end

  def button_down(id)
    case @screen
    when 1
      handle_game_screen_click(id)
    when 0
      handle_opening_screen_click(id)
    when -1
      @screen = 0 if id == Gosu::KbK
    end
    if id == Gosu::KbEscape # Check if player wants to exit this game
      close
      Menu.new(1, @records).show
    end
  end

  def handle_game_screen_click(id)
    return unless id == Gosu::MsLeft || id == Gosu::MsRight

    case
    when Gosu.distance(mouse_x, mouse_y, @x[0], @y[0]) < 50 && @visible[0] >= 0 && !rocks_clicking(mouse_x, mouse_y)
      @score += 1 + @level
      @hit = 1
    when Gosu.distance(mouse_x, mouse_y, @x[1], @y[1]) < 50 && @visible[1] >= 0 && !rocks_clicking(mouse_x, mouse_y)
      @score += 3 + @level
      @hit = 1
    when Gosu.distance(mouse_x, mouse_y, @x[2], @y[2]) < 50 && @visible[2] >= 0 && !rocks_clicking(mouse_x, mouse_y)
      @score += 5 + @level
      @hit = 1
    when Gosu.distance(mouse_x, mouse_y, @x[3], @y[3]) < 50 && @visible[3] >= 0 && !rocks_clicking(mouse_x, mouse_y)
      @score += 7 + @level
      @hit = 1
    when Gosu.distance(mouse_x, mouse_y, @x[4], @y[4]) < 60 && @visible[4] >= 0 && @time <= 5 && !rocks_clicking(mouse_x, mouse_y)
      @score += 15 + @level
      @hit = 1
    when rocks_clicking(mouse_x, mouse_y)
      @score -= 2
      @hit = -1
    else
      @score -= 1
      @hit = -1
    end
  end

  def handle_opening_screen_click(id)
    if id == Gosu::MsLeft
      if easy_click(mouse_x, mouse_y) || hard_click(mouse_x, mouse_y)
        @screen = 1
        @score = @visible = Array.new(5, 0)
        @start_time = Gosu.milliseconds
        @level = easy_click(mouse_x, mouse_y) ? 0 : 1
      end
    elsif id == Gosu::KbJ
      @screen = -1
      @instruction_y = 250
      @instruction_y_index = 0
    end
  end

  def update
    case @screen
    when -1
      update_instruction_screen
    when 1
      update_game_screen
    end
  end

  def update_instruction_screen
    if @instruction_y >= -270
      @instruction_y_index += 1
      @instruction_y_index = 0 if @instruction_y_index == 500
      @instruction_y -= 1 if (@instruction_y_index % 5) == 1
    else
      @instruction_y = 285
      @instruction_y_index = 0 if @instruction_y_index == 500
    end
  end

  def update_game_screen
    @time = 30 - ((Gosu.milliseconds - @start_time) / 1000)

    5.times do |i|
      @x[i] += @vx[i]
      @y[i] += @vy[i]
      if @x[i] - 40 > 720 || @x[i] - 40 < 0
        @vx[i] *= -1
      end
      if @y[i] - 34 > 532 || @y[i] - 34 < 0
        @vy[i] *= -1
      end
    end

    if @time <= 5
      @x[4] += @vx[4]
      @y[4] += @vy[4]
      @vx[4] *= -1 if (@x[4] - 50 > 700) || (@x[4] - 50 < 0)
      @vy[4] *= -1 if (@y[4] - 49 > 502) || (@y[4] - 49 < 0)
      @visible[4] -= 1
      @visible[4] = 20 if @visible[4] < -10
    end

    4.times do |i|
      @visible[i] -= 1
      @visible[i] = 20 if @visible[i] < -10
    end

    @rocks.push Rock.new(self) if @level == 1 && @rocks.size <= 10
    @rocks.each(&:move)

    if @time <= 0 || @score > 80
      @screen = 2
    end
  end

  def draw
    case @screen
    when 0
      draw_opening_screen
    when -1
      draw_instruction_screen
    when 1
      draw_game_screen
    when 2
      draw_ending_screen
    end
  end

  def draw_opening_screen
    @gemmining.draw(0, 0, 0)
    @start_song.play(true)
    
    @font.draw('Collecting', 160, 145, 0, 1.8, 1.8, Gosu::Color::AQUA)
    @font.draw('GEMS!!!', 400, 140, 0, 2.4, 2.4, Gosu::Color::FUCHSIA)
    @font.draw('<i>(Welcome to Phu\'s product)</i>', 260, 223, 0, 1.0, 1.0, Gosu::Color::RED)
    @font.draw('<i>Press J key for Instruction or</i>', 300, 415, 0, 0.6, 0.6, Gosu::Color::AQUA)
    @font.draw('<i>click one of these buttons to play!</i>', 310, 430, 0, 0.6, 0.6, Gosu::Color::AQUA)
    
    @easy_image.draw(280, 250, 0)
    @hard_image.draw(420, 250, 0)
    @image_mp_2.draw(mouse_x, mouse_y, 0)
  end

  def draw_instruction_screen
    @question.draw(0, 0, 0)
    @font.draw('Press K key to go back!', 210, 500, 0, 1.2, 1.2, Gosu::Color::RED)
    draw_instruction_text
    @image_mp_3.draw(mouse_x, mouse_y, 0)
  end

  def draw_instruction_text
    instruction = [
      '<i>Welcome to Gems Collecting! - An attractive game for every age</i>',
      'Move your mouse pointer and click on a gem to collect it.',
      'However, you must be careful with the rocks as you will lose points',
      'if you mistakenly click on them.',
      'There are 5 different types of gems, and each has its own value:',
      '- Emerald: 1 point',
      '- Ruby: 3 points',
      '- Sapphire: 5 points',
      '- Danburite: 7 points',
      '- Amethyst: 15 points',
      'Your aim is to collect 80 points within 30 seconds to complete this game.',
      'If the time is up and you haven\'t reached that score, you lose.',
      'Be cautious when your time is running out, as the Amethyst gem will appear.',
      'It gives you the most points, but also moves the fastest!',
      'Remember that in hard mode, rocks will randomly appear and distract you!',
      '<i>Have fun collecting gems!!!</i>'
    ]

    y_position = @instruction_y
    instruction.each do |line|
      @font.draw(line, 70, y_position, 0, 0.9, 0.9, Gosu::Color::FUCHSIA)
      y_position += 40
    end
  end

  def draw_game_screen
    @underground.draw(0, 0, 0)
    @game_song_1.play(true)
    
    gem_images = [@emerald, @ruby, @sapphire, @danburite, @amethyst]
    gem_images.each_with_index do |gem, i|
      gem.draw(@x[i] - 50, @y[i] - 49, 0) if @visible[i] > 0
    end

    @rocks.each(&:draw)
    draw_score
  end

  def draw_score
    color = case @hit
            when 0 then Gosu::Color::NONE
            when 1 then Gosu::Color::GREEN
            when -1 then Gosu::Color::RED
            end

    @hammer.draw(mouse_x, mouse_y, 0)
    @font.draw(@score.to_s, 700, 20, 0, 1.0, 1.0, color)
    @font.draw("Timer: #{@time.to_i}", 600, 20, 0, 1.0, 1.0, Gosu::Color::RED)
  end

  def draw_ending_screen
    @end_song.play(false)
    @font.draw('Press ESC to return to the menu', 200, 400, 0, 2.0, 2.0, Gosu::Color::YELLOW)
    if @score >= 80
      @font.draw('YOU WIN!!!', 250, 250, 0, 3.0, 3.0, Gosu::Color::FUCHSIA)
      @records[@count_index] = @score
    else
      @font.draw('YOU LOSE!!!', 250, 250, 0, 3.0, 3.0, Gosu::Color::RED)
    end
    @font.draw("Your score: #{@score}", 250, 150, 0, 3.0, 3.0, Gosu::Color::GREEN)
  end

  private

  def easy_click(mouse_x, mouse_y)
    (mouse_x - 280).between?(0, 115) && (mouse_y - 250).between?(0, 115)
  end

  def hard_click(mouse_x, mouse_y)
    (mouse_x - 420).between?(0, 115) && (mouse_y - 250).between?(0, 115)
  end
end
records = [] # Placeholder for actual records
GemsCollection.new(records).show