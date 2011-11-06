class Host
  attr_accessor :host, :port
  def initialize host, port
    @host =     host
    @port =     port
  end
  def to_s
    "#{@host}:#{@port}"
  end
end