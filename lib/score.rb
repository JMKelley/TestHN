class Score

  ANCHOR = Time.now - 1.year

  attr_reader :score, :date

  def initialize(likes, dislikes, date)
    @score = likes - dislikes
    @date = date
  end

  def value
    (order * sign.to_f) + ( seconds / 45000)
  end

  def sign
    if score > 0
      1
    elsif score < 0
      -1
    else
      0
    end
  end

  def order
    Math.log([score.abs, 1].max, 10)
  end

  def seconds
    epoch date
  end

  private

  def epoch(time)
    (time.to_i - ANCHOR.to_i).to_f
  end

end