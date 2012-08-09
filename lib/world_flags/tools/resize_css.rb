# use ImageMagick to Resize, using 32px version as base
# convert flags32.png -resize 75% flags24.png
# convert flags32_semi.png -resize 75% flags24_semi.png

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
    
    command1 = "convert #{sprite_name}#{base_size}.png -resize #{factor * 100}% #{sprite_name}#{new_size}.png"
    command2 = "convert #{sprite_name}#{base_size}_semi.png -resize #{factor * 100}% #{sprite_name}#{new_size}_semi.png"

    if auto_exec?
      %x[command1]
      %x[command2]
    else
      puts "Use ImageMagick to resize #{sprite_name} sprites:"  
      puts command1
      puts command2
    end
  end

  def auto_exec?
    options[:auto_exec]
  end

  def size_prefix
    @size_prefix ||= 'f'
  end

  def stylesheet_path
    "../../../vendor/assets/stylesheets"
  end

  def stylesheet_folder
    @stylesheet_folder ||= "flags"
  end

  def stylesheet_full_path
    @stylesheet_full_path ||= File.join(stylesheet_path, stylesheet_folder)
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
    template_lang ? ".#{template_lang}" : ''
  end

  def execute options = {:ext => 'css', :semi => false}
    semi = options[:semi] ? '-semi': ''
    ext = options[:ext] ? options[:ext] : 'css'
    src_file_path = File.expand_path "#{stylesheet_full_path}/#{stylesheet_name}#{base_size}#{semi}.#{ext}#{template_ext}", File.dirname(__FILE__)
    target_file_path = File.expand_path "#{stylesheet_full_path}/flags/flags#{new_size}#{semi}.#{ext}#{template_ext}", File.dirname(__FILE__)

    lines = File.open(src_file_path).readlines

    img_exp = "#{sprite_name}#{base_size}"
    replace_img = "#{sprite_name}#{new_size}"

    repositioned_css = lines.map do |line|
      pos_match = line.match /.+position:0 -(\d+)px.*/
      img_match = line.match /#{img_exp}/
      new_line = line.sub(/#{img_exp}/, replace_img) if img_match
      new_line = replace_pos pos_match, line if pos_match
      new_line ||= line
      new_line
    end.join("")

    File.open(target_file_path, 'w') do |f|
      f.puts repositioned_css.gsub ".#{size_prefix}#{base_size}", ".#{size_prefix}#{new_size}"
    end
  end

  def factor
    @factor ||= new_size / base_size
  end

  def replace_pos pos_match, line
    pos_y = pos_match[1].to_i        
    new_pos_y = (pos_y * factor).to_i.to_s
    # puts "pos: #{pos_y} -> #{new_pos_y}"
    rest = line[10..-1]
    rest = rest.sub /#{pos_y}/, new_pos_y.to_s
    # first = line[0..10].sub(".f#{base_size}", ".f#{newsize}") 
    line[0..10] + rest
  end
end

# change last argument to fit sprite size of flags
# first arg is the flag size (css files) that is used as base
resizer = ResizeCss.new 24, 48

resizer.execute 
resizer.execute :ext => 'css.scss'

resizer.execute :semi => true
resizer.execute :ext => 'css.scss', :semi => true
