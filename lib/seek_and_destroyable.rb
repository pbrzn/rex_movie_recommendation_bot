module SeekAndDestroyable

  def find_by_name(name)
    self.all.find {|i| i.name==name}
  end

  def destroy_all
    self.all.clear
  end
end
