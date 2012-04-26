class Hash
  def hash_revert
    r = Hash.new
    each {|k,v| r[v] = k}
    r
  end
end

class Array
  def downcase
    self.map{|e| e.to_s.downcase}
  end

  def upcase
    self.map{|e| e.to_s.upcase}
  end

  def select_first_in *list
    list = list.flatten.compact   
    self.each {|e| return e if list.include?(e) }
  end
end
