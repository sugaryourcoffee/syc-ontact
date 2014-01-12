require 'sycontact/address_book_library'

module Sycontact

  describe AddressBookLibrary do
    
    before do
      address_book_directory = File.join(File.dirname(__FILE__), "files")
      @library = AddressBookLibrary.new(address_book_directory)
    end

    it "should look up contact" do
      @library.lookup(sn: "sugar").should_not be_empty
    end

  end

end
