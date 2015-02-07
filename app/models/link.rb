class Link < ActiveRecord::Base
	acts_as_votable
	belongs_to :user
	before_save :update_weighted_score

	# Raw scores are = upvotes - downvotes
  def raw_score
    self.get_upvotes.size - self.get_downvotes.size
  end

  def weighted_score(*args)
    order = Math.log([raw_score.abs, 1].max, 10)
    sign = if raw_score > 0
      1
    elsif raw_score < 0
      -1
    else
      0
    end
    seconds = self.created_at.to_i - (Time.now - 1.year).to_i
    ((order + sign * seconds / 45000) * 7).ceil / 7.0
  end

  private

  def update_weighted_score
  	if cached_votes_total_changed?
  		self.weighted_score = weighted_score
  	end
  end

end
