class Inventory
attr_accessor :items
	def initialize slots
		@items = Array.new(slots) { InvItem.new 0, 0, 0 }
	end
end

class InvItem
attr_accessor :type, :data, :amount
	def initialize type, data, amount
		@type = type
		@data = data
		@amount = amount
	end
end
