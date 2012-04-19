class Statistic

  # Valor de cada download
  TOTAL_VALUE = 0.05

  # Valor de cada download em segundo nivel
  REFERRED_VALUE = 0.2 * TOTAL_VALUE

  def total_revenue
    revenue + referred_revenue
  end

end
