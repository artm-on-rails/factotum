module OccupationDecorator
  def tooltip
    master = self.master ? "Master " : ""
    "#{jack.email} is a #{master}#{trade.name}"
  end

  def destroy_tooltip
    "Unoccupy #{jack.email} from #{trade.name} trade"
  end
end
