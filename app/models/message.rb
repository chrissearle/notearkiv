class Message < ActiveRecord::Base
  validates_presence_of :title, :content, :msgtype

  scope :active, -> { where(:active_flag => true) }
  scope :started, -> { where('startdt <= ? OR startdt is null', Time.zone.now) }
  scope :ended, -> { where('enddt >= ? OR enddt is null', Time.zone.now) }

  def startdt_text
    startdt.try(:strftime, '%Y-%m-%d %H:%M:%S')
  end

  def startdt_text= (time)
    self.startdt = Time.zone.parse(time) if time.present?
  rescue ArgumentError
    self.startdt = nil
  end

  def enddt_text
    enddt.try(:strftime, '%Y-%m-%d %H:%M:%S')
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

  def self.system_messages
    data = []
    Dir.foreach(Rails.root.join('messages')) do |filename|
      if filename.end_with? '.md'
        msg = Message.new
        msg.content = File.read(Rails.root.join('messages', filename))

        if filename.end_with? '.info.md'
          msg.msgtype = 'info'
        elsif filename.end_with? '.warning.md'
          msg.msgtype = 'warning'
        elsif filename.end_with? '.error.md'
          msg.msgtype = 'error'
        else
          msg.msgtype = 'error'
        end

        data << msg
      end
    end
    data
  end
end
