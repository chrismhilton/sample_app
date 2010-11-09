class User
  # create attribute accessors; this creates “getter” and “setter” methods
  attr_accessor :name, :email

  # initialize method - special in Ruby: it’s the method called when we execute User.new
  # attributes arguement - variable has a default value equal to empty hash so can create a user with no name or email
  # hashes return nil for nonexistent keys, so attributes[:name] will be nil if there is no :name key
  def initialize(attributes = {})
    @name  = attributes[:name]
    @email = attributes[:email]
  end

  # returns formatted string using interpolation
  def formatted_email
    "#{@name} <#{@email}>"
  end
end
