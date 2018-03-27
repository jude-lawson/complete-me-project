class Node
  attr_accessor :weight, 
                :flag, 
                :children

  def initialize
    @weight = {}
    @flag = false
    @children = {}
  end

  def has_children?
    !@children.empty?
  end

end
