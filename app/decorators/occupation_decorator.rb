module OccupationDecorator
  def tooltip
    master = self.master ? "Master " : ""
    "#{jack.email} is a #{master}#{trade.name}"
  end
end
