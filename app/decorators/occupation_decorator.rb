# frozen_string_literal: true

# Occupation decorator: methods added to an occupation model in views
module OccupationDecorator
  def tooltip
    master = self.master ? "Master " : ""
    "#{jack.email} is a #{master}#{trade.name}"
  end

  def destroy_tooltip
    if new_record?
      "Cancel adding this trade"
    else
      "Unoccupy #{jack.email} from #{trade.name} trade"
    end
  end
end
