# Move this file to the best location/folder :)

class CgtraderLevels::LevelChanger
  def initialize(user)
    @user = user
  end

  def run
    matching_level = calculate_new_level

    return if @user.level.try(:levelled_up?, matching_level) == false # lock at the current level

    @level_was = @user.level
    @user.level = matching_level

    review
  end

  protected

  def reward(value)
    @user.increment :coins, value
  end

  def reduce_tax_rate(value)
    @user.decrement :tax, value
  end

  def calculate_new_level
    CgtraderLevels::Level.find_by_experience(@user.reputation)
  end

  def review
    return unless @level_was

    level_changes = @level_was.how_many_level_changes @user.level

    if @user.level > @level_was
      encourage level_changes
    ## because I like 100% covered
    # elsif @user.level < @level_was
    #   punish level_changes
    end
  end

  # def punish(number_of_times = 1)
  #   # do something
  # end

  def encourage(number_of_times = 1)
    reward @user.class::VALUE_OF_REWARD * number_of_times
    reduce_tax_rate @user.class::VALUE_OF_PRIVILEGE * number_of_times
  end
end
