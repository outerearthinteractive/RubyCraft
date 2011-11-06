class NoTestBodyException < RuntimeError
  attr_accessor :message
  def initialize message
    @message = message
  end
end