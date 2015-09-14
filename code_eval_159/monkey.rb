class String

  def to_coord!
    self.split(';').map!(&:to_f)
  end
end