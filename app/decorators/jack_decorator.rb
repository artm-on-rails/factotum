module JackDecorator
  def of_all_trades_tooltip
    "#{email} is jack of all trades" if of_all_trades?
  end
end
