class Link < ActiveRecord::Base
	acts_as_votable
	belongs_to :user
	before_save :update_score

  mount_uploader :image, ImageUploader

  def score
    ::Score.new(get_likes.count, get_dislikes.count, self.created_at || Time.now).value
  end

  def is_owner?(user)
    self.user_id == user_id
  end

  private

  def update_score
  	if cached_votes_total_changed?
  		self.score = score
  	end
  end

end
