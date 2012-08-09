# use ImageMagick to Resize, using 32px version as base
# convert flags32.png -resize 75% flags24.png
# convert flags32_semi.png -resize 75% flags24_semi.png

require 'open3'

# TODO: Needs some heavy refactoring and cleaning up!

class ResizeCss

  attr_reader :base_size, :new_size, :stylesheet_folder, :stylesheet_name, :sprite_name
  attr_reader :template_lang, :size_prefix, :options

  def initialize base_size, new_size, options
    @base_size  = base_size
    @new_size   = new_size
    @options    = options

    @stylesheet_folder = options[:stylesheet_folder]  if options[:stylesheet_folder]
    @stylesheet_name   = options[:stylesheet_name]    if options[:stylesheet_name]
    @sprite_name       = options[:sprite_name]        if options[:sprite_name]
    @template_lang     = options[:template_lang]      if options[:template_lang]
    @size_prefix       = options[:size_prefix]        if options[:size_prefix]
    
    resize = "convert #{sprite_name}#{base_size}.png -resize #{factor * 100}%"
    new_file_name = "#{sprite_name}#{new_size}"

    command_resize = "#{resize} #{new_file_name}.png"
    command_resize_light = "#{resize} #{lighten} #{new_file_name}_light.png"
    command_resize_dark  = "#{resize} #{darken} #{new_file_name}_dark.png"
    command_resize_gray  = "#{resize} #{grayscale} #{new_file_name}_gray.png"

    if auto_exec?
      Open3.popen3("pwd") do |stdin, stdout, e, t|
        base_dir = stdout
        Open3.popen3 "cd #{images_dir}"

        Open3.popen3 command_resize
        Open3.popen3 command_resize_light if lighten?
        Open3.popen3 command_resize_dark if darken?
        Open3.popen3 command_resize_gray if gray? 

        Open3.popen3 "cd #{base_dir}"
      end
    else
      puts "Use ImageMagick to resize #{sprite_name} sprites:"  
      puts command_resize
      puts command_resize_light if lighten?
      puts command_resize_dark if darken?
      puts command_resize_gray if gray? 
    end
  end

  def lighten?
    options[:light]
  end

  def darken?
    options[:dark]
  end

  def gray?
    options[:gray]
  end

  def lighten
    "-level 0%,100%,2.0"
  end

  def darken
    "-level 0%,100%,0.5"
  end

  def grayscale
    "-colorspace Gray"
  end

  def auto_exec?
    options[:auto_exec]
  end

  def size_prefix
    @size_prefix ||= 'f'
  end

  def vendor_assets_path
    "../../../vendor/assets/"
  end

  def images_dir
    @images_dir ||= File.join(vendor_assets_path, 'images')
  end

  def stylesheets_dir
    @stylesheets_dir ||= File.join(vendor_assets_path, 'stylesheets')
  end

  def stylesheets_folder
    @stylesheets_folder ||= "flags"
  end

  def stylesheet_full_path
    @stylesheet_full_path ||= File.join(stylesheets_dir, stylesheets_folder)
  end

  def stylesheet_name
    @stylesheet_name ||= 'flags'
  end

  def sprite_name
    @sprite_name ||= 'flags'
  end

  def template_lang
    @template_lang ||= 'erb'
  end

  def template_ext
    !blank?(template_lang) ? ".#{template_lang}" : ''
  end

  def blank? txt
    !txt || txt.empty?
  end

  def execute options = {:ext => 'css', :semi => false}
    semi = options[:semi] ? '-semi': ''
    ext = options[:ext] ? options[:ext] : 'css'
    src_file_path = File.expand_path "#{stylesheet_full_path}/#{stylesheet_name}#{base_size}#{semi}.#{ext}#{template_ext}", File.dirname(__FILE__)
    target_file_path = File.expand_path "#{stylesheet_full_path}/#{stylesheet_name}#{new_size}#{semi}.#{ext}#{template_ext}", File.dirname(__FILE__)

    puts "src: #{src_file_path} -> #{target_file_path}"

    lines = File.open(src_file_path).readlines

    img_exp = "#{sprite_name}-#{base_size}"
    replace_img = "#{sprite_name}-#{new_size}"

    # puts "img_exp: #{img_exp}"
    # puts "replace_img: #{replace_img}"

    repositioned_css = lines.map do |line|
      pos_match = line.match /.+position:\s-?(\d+)(px)?\s-?(\d+)(px)?/
      # puts "pos_match: #{line} - #{pos_match.inspect}"
      img_match = line.match /#{img_exp}/
      new_line = line.sub(/#{img_exp}/, replace_img) if img_match
      new_line = replace_pos pos_match, line if pos_match
      # puts "line: #{line} -> #{new_line}"
      new_line ||= line
      new_line
    end.join("")

    puts "Write new CSS:"
    puts repositioned_css
    
    File.open(target_file_path, 'w') do |f|
      f.puts repositioned_css.gsub ".#{size_prefix}#{base_size}", ".#{size_prefix}#{new_size}"
    end
  end

  def factor
    @factor ||= new_size / base_size.to_f
  end

  def replace_pos pos_match, line
    pos_x = pos_match[1].to_i        
    new_pos_x = (pos_x * factor).to_i.to_s

    pos_y = pos_match[3].to_i        
    new_pos_y = (pos_y * factor).to_i.to_s
    
    # puts "new pos: #{new_pos_x}, #{new_pos_y}"
    
    rest = line[6..-1]
    rest = rest.sub /#{pos_x}/, new_pos_x.to_s
    rest = rest.sub /#{pos_y}/, new_pos_y.to_s

    rest = rest.gsub /#{base_size}px;/, "#{new_size}px;"

    # first = line[0..10].sub(".f#{base_size}", ".f#{newsize}") 
    line[0..5] + rest
  end
end
# options
# - :stylesheet_folder, :stylesheet_name, :sprite_name, :template_lang, :size_prefix
# - :dark, :light, :gray
# - :auto-exec

# change last argument to fit sprite size of flags
# first arg is the flag size (css files) that is used as base
resizer = ResizeCss.new 24, 48


resizer.execute 
resizer.execute :ext => 'css.scss'

# resizer.execute :semi => true
# resizer.execute :ext => 'css.scss', :semi => true
