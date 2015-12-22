class CgtraderLevels::Level < ActiveRecord::Base
  include Comparable

  has_many :users

  default_scope -> { order(experience: :asc) }

  scope :by_experience, -> experience { where('experience <= ?', experience) }

  def self.find_by_experience(experience)
    by_experience(experience).last
  end

  def <=>(another)
    experience <=> another.experience
  end

  def how_many_level_changes(new_level)
    new_level && CgtraderLevels::Level.where(experience: experience_range(new_level)).count - 1
  end

  def levelled_up?(new_level)
    new_level.try :>, self
  end

  private

  def experience_range(other_level)
    experiences = [self.experience, other_level.experience].sort
    experiences.first..experiences.last
  end
end
