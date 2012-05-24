# use ImageMagick to Resize, using 32px version as base
# convert flags32.png -resize 75% flags24.png
# convert flags32_semi.png -resize 75% flags24_semi.png

class ResizeCss

  attr_reader :base_size, :new_size

  def initialize base_size, new_size
    @base_size = base_size
    @new_size = new_size
  end

  def execute options = {:ext => 'css', :semi => false}
    semi = options[:semi] ? '-semi': ''
    ext = options[:ext] ? options[:ext] : 'css'
    src_file_path = File.expand_path "../../../vendor/assets/stylesheets/flags/flags#{base_size}#{semi}.#{ext}.erb", File.dirname(__FILE__)
    target_file_path = File.expand_path "../../../vendor/assets/stylesheets/flags/flags#{new_size}#{semi}.#{ext}.erb", File.dirname(__FILE__)

    lines = File.open(src_file_path).readlines

    img_exp = "flags#{base_size}"
    replace_img = "flags#{new_size}"

    repositioned_css = lines.map do |line|
      pos_match = line.match /.+position:0 -(\d+)px.*/
      img_match = line.match /#{img_exp}/
      new_line = line.sub(/#{img_exp}/, replace_img) if img_match
      new_line = replace_pos pos_match, line if pos_match
      new_line ||= line
      new_line
    end

    File.open(target_file_path, 'w') do |f|
      f.puts repositioned_css
    end
  end

  def replace_pos pos_match, line
    pos_y = pos_match[1].to_i        
    new_pos_y = (pos_y * 0.75).to_i.to_s
    # puts "pos: #{pos_y} -> #{new_pos_y}"
    rest = line[10..-1]
    rest = rest.sub /#{pos_y}/, new_pos_y.to_s
    line[0..10] + rest
  end
end

# change last argument to fit sprite size of flags
# first arg is the flag size (css files) that is used as base
resizer = ResizeCss.new 32, 48

resizer.execute 
resizer.execute :ext => 'css.scss'

resizer.execute :semi => true
resizer.execute :ext => 'css.scss', :semi => true
