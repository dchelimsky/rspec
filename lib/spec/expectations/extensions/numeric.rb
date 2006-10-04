class Numeric
  def close?(other, precision)
    (self - other).abs < precision
  end
end