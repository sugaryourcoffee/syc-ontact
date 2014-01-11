module Sycontact

  class AddressBook
  
    def initialize(source)
      require source.sub('.rb', '')
      extend AddressSource
    end

  end
end
