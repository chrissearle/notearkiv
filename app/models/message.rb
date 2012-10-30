class Message < ActiveRecord::Base
  attr_accessible :active_flag, :content, :enddt, :msgtype, :startdt, :title, :startdt_text, :enddt_text

  validates_presence_of :title, :content, :msgtype

  scope :active,  -> { where(:active_flag => true) }
  scope :started, -> { where("startdt <= ? OR startdt is null", Time.zone.now) }
  scope :ended,   -> { where("enddt >= ? OR enddt is null", Time.zone.now) }

  def startdt_text
    startdt.try(:strftime, "%Y-%m-%d %H:%M:%S")
  end
  def startdt_text= (time)
    self.startdt = Time.zone.parse(time) if time.present?
  rescue ArgumentError
    self.startdt = nil
  end
  def enddt_text
    enddt.try(:strftime, "%Y-%m-%d %H:%M:%S")
  end
  def enddt_text= (time)
    self.enddt = Time.zone.parse(time) if time.present?
  rescue ArgumentError
    self.enddt = nil
  end

  def deletable?
    true
  end

  def self.find_currently_active
    self.active.started.ended
  end
end
