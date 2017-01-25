require 'hocon'

class Stationmaster::BoardingInfo
  def initialize(path)
    @config = Hocon.load(path)
  end

  def to_s
    @config.to_s
  end
end
