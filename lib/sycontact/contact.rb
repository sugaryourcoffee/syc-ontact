module Sycontact

  class Contact

    def initialize(attributes)
      @attributes = attributes
    end

    def method_missing(name, *args, &block)
      @attributes[name]
    end
  end

end
