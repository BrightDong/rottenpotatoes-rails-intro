class Movie < ActiveRecord::Base



def self.rating_filtered(filter)
    if filter == [] || filter.nil?
	  return self.all
	else
      self.where(rating: filter)
	end
end

def self.all_ratings
  self.uniq.pluck(:rating)
end

end
