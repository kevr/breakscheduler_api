module JsonHelper
  def decode(string)
    return ActiveSupport::JSON.decode(string)
  end

  def encode(object)
    return ActiveSupport::JSON.encode(object)
  end

  def get_json(object)
    return decode(encode(object))
  end
end
