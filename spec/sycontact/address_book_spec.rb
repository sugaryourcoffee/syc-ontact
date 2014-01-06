require 'sycontact/address_book'

module Sycontact
  describe AddressBook do

    before do
      source_file = File.join(File.dirname(__FILE__), "files/source")
      @address_book = AddressBook.new(source_file)
    end

    it "respond to attributes" do
      @address_book.should respond_to :url_type
      @address_book.should respond_to :url
      @address_book.should respond_to :patterns
    end

    it "should have an URL and URL type" do
      @address_book.url_type.should eq 'file'
      @address_book.url.should eq '~/work/sycontact/contactfiles/test-source'
    end

    it "should have patterns" do
      @address_book.patterns.size.should eq 13
    end

    it "find should return contact when it can be found" do
      @address_book.lookup(c: "DE", 
                           sn: "Pierre", 
                           mail: "example@user.com").should_not be_nil
    end

    it "find should return nil when contact cannot be found" do
      @address_book.lookup(c: "DE", 
                           sn: "No Name").should be_nil
    end
  end
end
