class Symbol
  def supported_by_rspec?
    return ["<","<=",">=",">","==","=~"].include?(to_s)
  end
end
