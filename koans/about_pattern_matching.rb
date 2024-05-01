require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutPatternMatching < Neo::Koan

  def test_pattern_may_not_match
    begin
      case [true, false]
      in [a, b] if a == b # The condition after pattern is called guard.
        :match
      end
      # What exception has been caught?
    end
  end

  def test_we_can_use_else
    result = case [true, false]
    in [a, b] if a == b
      :match
             else
               :no_match
             end

  end

  # ------------------------------------------------------------------

  def value_pattern(variable)
    case variable
    in 0
      :match_exact_value
    in 1..10
      :match_in_range
    in Integer
      :match_with_class
    else
      :no_match
    end
  end

  def test_value_pattern
  end

  # ------------------------------------------------------------------
  # This pattern will bind variable to the value

  def variable_pattern_with_binding(variable)
    case 0
    in variable
      variable
    else
      :no_match
    end
  end

  def test_variable_pattern_with_binding
  end

  # ------------------------------------------------------------------

  # We can pin the value of the variable with ^

  def variable_pattern_with_pin(variable)
    case 0
    in ^variable
      variable
    else
      :no_match
    end
  end

  def test_variable_pattern_with_pin
  end

  # ------------------------------------------------------------------

  # We can drop values from pattern

  def pattern_with_dropping(variable)
    case variable
    in [_, 2]
      :match
    else
      :no_match
    end
  end

  def test_pattern_with_dropping
  end

  # ------------------------------------------------------------------

  # We can use logical *or* in patterns

  def alternative_pattern(variable)
    case variable
    in 0 | false | nil
      :match
    else
      :no_match
    end
  end

  def test_alternative_pattern
  end

  # ------------------------------------------------------------------

  # As pattern binds the variable to the value if pattern matches
  # pat: pat => var

  def as_pattern
    a = 'First I was afraid'

    case 'I was petrified'
    in String => a
      a
    else
      :no_match
    end
  end

  def test_as_pattern
  end

  # ------------------------------------------------------------------

  # Array pattern works with all objects that have #deconstruct method that returns Array
  # It is useful to cut needed parts from Array-ish objects

  class Deconstructible
    def initialize(str)
      @data = str
    end

    def deconstruct
      @data&.split('')
    end
  end

  def array_pattern(deconstructible)
    case deconstructible
    in 'a', *res, 'd'
      res
    else
      :no_match
    end
  end

  def test_array_pattern
  end

  # ------------------------------------------------------------------

  # Hash pattern is quite the same as Array pattern, but it expects #deconsturct_keys(keys) method
  # It works with symbol keys for now

  class LetterAccountant
    def initialize(str)
      @data = str
    end

    def deconstruct_keys(keys)
      # we will count number of occurrences of each key in our data
      keys.map { |key| [key, @data.count(key.to_s)] }.to_h
    end
  end

  def hash_pattern(deconstructible_as_hash)
    case deconstructible_as_hash
    in {a: a, b: b}
      [a, b]
    else
    end
  end

  def test_hash_pattern
  end

  # we can write it even shorter
  def hash_pattern_with_sugar(deconstructible_as_hash)
    case deconstructible_as_hash
    in a:, b:
      [a, b]
    else
    end
  end

  def test_hash_pattern_with_sugar
  end

end
