class Setting < ActiveRecord::Base
	store_accessor :values, :time_weight, :answer_weight

	class << self
		def get(var)
			Setting.first.try(var)
		end

		def set(var, val)
			setting = Setting.first || Setting.create
			setting.update_attribute(var, val)
		end
	end
end
