class CgtraderLevels::User < ActiveRecord::Base
  VALUE_OF_REWARD = 7
  VALUE_OF_PRIVILEGE = 1

  cattr_writer :level_changer

  def self.level_changer
    @@level_changer || CgtraderLevels::LevelChanger
  end

  belongs_to :level

  after_initialize :set_reputation

  before_save :assign_new_level, if: :reputation_changed?

  private

  def set_reputation
    self.reputation ||= 0 if self.new_record?
    assign_new_level if self.new_record? # according to the tests, but I wouldn't do that
  end

  def assign_new_level
    self.class.level_changer.new(self).run
  end
end
