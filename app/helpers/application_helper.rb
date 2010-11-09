module ApplicationHelper

  # A helper, which is a function/method designed for use in views

  # Return a title on a per-page basis
  # Ruby modules can be included in Ruby classes but Rails handles the inclusion automatically
  # with the result that the title method is automagically available in all our views
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      # build up string via interpolation using the special syntax #{}
      # NB: single-quoted strings don't allow interpolation
      "#{base_title} | #{@title}"
    end
  end

  # Return logo image tag using Rails helper "image_tag" (passing has of options)
  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

  #
  # Strings and Objects
  #

  # Everything in Ruby, including strings and even nil, is an object
  # Booleans can also be combined using the && (“and”), || (“or”), and ! (“not”) operators
  # The to_s method that can convert virtually any object to a string
  # Instance variables are nil if not defined
  def string_object_examples
    first_name = "Michael"
    last_name = "Hartl"
    name = first_name + " " + last_name    # Concatenation, with a space in between
    name = "#{first_name} #{last_name}"    # The equivalent interpolation

    name = '#{foo} bar'     # Single-quoted strings don't allow interpolation

    "foobar".length
    "foobar".empty?

    x = "foo" # ordinary (not instance) variable
    y = ""
    if x.empty? && y.empty?
      "both are empty"
    elsif x.empty? || y.empty?
      "one is empty"
    elsif !x.empty?
      "x is not empty"
    end

    y = nil.to_s # object to string
    nil.nil? # true
    @undefined.nil? # true

    "".blank?         # => true
    "      ".empty?   # => false
    "      ".blank?   # => true
    nil.blank?        # => true

    # from exercise:
    s = 'abc_def_ghi_jkl_mno_pqr_stu_vwx_yz'
    s.split('_').shuffle.join(':')
    s.split('').shuffle.join(':')
  end

  #
  # Method definitions
  #

  # Ruby functions have an implicit return, meaning they return the last statement evaluated
  # Question mark at the end of the empty? method is a Ruby convention
  # indicating that the return value is boolean: true or false
  def string_message(string)
    if string.empty?
      "It's an empty string!"
    else
      "The string is nonempty."
    end
  end

  # Ruby also has an explicit return option; the following function is equivalent to the one above
  def string_message2(string)
    return "It's an empty string!" if string.empty?
    return "The string is nonempty."
  end

  # Ruby allows you to write a statement that is evaluated only if the statement following if is true
  # There’s a complementary unless keyword that works the same way
  def string_message3(string)
    return "The string is nonempty." unless string.empty?
  end

  #
  # Arrays and Ranges
  #

  # An array is just a list of elements in a particular order
  def array_examples
    "foo bar     baz".split     # Split a string into a three-element array of strings (on white space by default) => ["foo", "bar", "baz"]
    "fooxbarxbazx".split('x')   # Split using character => ["foo", "bar", "baz"]

    a = [42, 8, 17]

    first_element = a[0]        # => 42
    last_element = a[-1]        # => 17
    first_element = a.first     # => 42
    second_element = a.second   # => 8
    last_element = a.last       # => 17

    a[1] == a.second            # => true
    a[0] != a.last              # => true
    a[0] >= 43                  # => false

    # array methods
    a.sort                      # => [8, 17, 42]
    a.reverse                   # => [17, 8, 42]
    a.shuffle                   # => [17, 42, 8]

    # add to array
    # Ruby arrays can contain a mixture of different types
    a << 7                      # => [42, 8, 17, 7]
    a << "foo" << "bar"         # => [42, 8, 17, 7, "foo", "bar"]

    # array methods
    a.join                      # => "428177foobar"
    a.join(', ')                # => "42, 8, 17, 7, foo, bar"

    # ranges
    (0..9).to_a                 # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    a = %w[foo bar baz quux]    # Use %w to make a string array.
    a[0..2]                     # => ["foo", "bar", "baz"]
    ('a'..'e').to_a             # => ["a", "b", "c", "d", "e"]
  end

  #
  # Blocks
  # both arrays and ranges respond to a host of methods that accept blocks
  #

  def block_examples

    # calls each method on range ands passes it block
    # |i| is Ruby syntax for block variable
    # {} one way to indicate a clock
    (1..5).each { |i| puts 2 * i}   # outputs 2 4 6 8 10

    # blocks can be more than one line using do..end syntax
    (1..5).each do |number|
      puts 2 * number
      puts '--'
    end

    # more block examples

    # 3.times takes a block with no variables
    3.times { puts "Betelgeuse!" }        # outputs "Betelgeuse!" three times

    # the map method returns the result of applying the given block to each element in the array or range
    # the ** notation is for 'power'
    (1..5).map { |i| i**2 }               # => [1, 4, 9, 16, 25]

    # recall that %w makes string arrays
    %w[a b c]                             # => ["a", "b", "c"]
    %w[a b c].map { |char| char.upcase }  # => ["A", "B", "C"]

    # array of alaphabet, shuffled then return first eight elements and join them
    ('a'..'z').to_a.shuffle[0..7].join    # => "mznpybuj"
  end

  #
  # Hashes and Symbols
  # Hashes are basically like arrays, but not limited to integer indices
  # Hashes are indicated with curly braces containing key-value pairs
  # Hashes don't generally guarantee keeping their elements in a particular order
  # so if order matters, use an array.
  #
  def hashes_examples

    user = {}                          # {} is an empty hash.

    user["first_name"] = "Michael"     # Key "first_name", value "Michael"
    user["last_name"] = "Hartl"        # Key "last_name", value "Hartl"
    user["first_name"]                 # Element access is like arrays.

    # A literal representation of the hash
    user                               # => {"last_name"=>"Hartl", "first_name"=>"Michael"}

    # Instead of defining hashes one item at a time using square brackets,
    # it’s easy to use their literal representation
    user = { "first_name" => "Michael", "last_name" => "Hartl" }

    # In Rails more common to use symbols as hash keys
    # Symbols look kind of like strings, but prefixed with a colon instead of surrounded by quotes.
    # For example, :name is a symbol. Symbols as basically strings without all the extra baggage.
    # Symbols are a special Ruby data type
    user = { :name => "Michael Hartl", :email => "michael@example.com" }

    user[:name]                       # => "Michael Hartl"
    user[:password]                   # => nil (undefined key)

    # Hash values can be virtually anything, even other hashes (hashes-of-hashes, or nested hashes)
    params = {}
    params[:user] = { :name => "Michael Hartl", :email => "mhartl@example.com" }

    params                            # => {:user=>{:name=>"Michael Hartl", :email=>"mhartl@example.com"}}
    params[:user][:email]             # => "mhartl@example.com"

    # As with arrays and ranges, hashes respond to the each method
    # with a block that takes two variables
    # the each method for a hash iterates through the hash one key-value pair at a time
    flash = { :success => "It worked!", :error => "It failed. :-(" }
    flash.each do |key, value|
      puts "Key #{key.inspect} has value #{value.inspect}"
    end
    # outputs:
    # Key :success has value "It worked!"
    # Key :error has value "It failed. :-("

    # The inspect method, which returns a string with a literal representation of the object it’s called on
    puts (1..5).to_a.inspect          # => [1, 2, 3, 4, 5]

    puts :name, :name.inspect
    # outputs:
    # name
    # :name

    puts "It worked!", "It worked!".inspect
    # outputs:
    # It worked!
    # "It worked!"

    p :name     # Same as 'puts :name.inspect'
  end
end
