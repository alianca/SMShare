module Admin::FinancesHelper

  def date_select(name)
    select(name, 'day', [["Dia", nil]] + (1..31).map { |d| ["#{d}", d] }).to_s +
    select(name, 'month', [["Mês", nil]] + (1..12).map { |m| ["#{m}", m] }).to_s +
    select(name, 'year', [["Ano", nil]] + (DateTime.now.year-50..DateTime.now.year).map { |y| ["#{y}", y] }).to_s
  end

end
