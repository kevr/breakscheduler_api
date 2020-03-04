# A Guest user. This should be a user authenticated by a guest key.
# One such model that has a guest key is Ticket, under Ticket.key
#
class GuestUser

  attr_accessor :id
  attr_accessor :name
  attr_accessor :email

  def initialize(params = {})
    self.id = nil
    if params.include?(:id)
      self.id = params[:id]
    end

    self.name = ''
    if params.include?(:name)
      self.name = params[:name]
    end

    self.email = nil
    if params.include?(:email)
      self.email = params[:email]
    end

    if self.email == nil
      raise ActiveRecord::StatementInvalid.new "email required"
    end
  end

  def as_json(options = {})
    {
      "id" => nil,
      "name" => self.name,
      "email" => self.email,
      "registered" => false
    }
  end

end
