require 'sycontact/address_book'

module Sycontact
  describe AddressBook do

    before do
      source_file = File.join(File.dirname(__FILE__), "files/address_source.rb")
      @address_book = AddressBook.new(source_file)
    end

    it "finds contact with sn and gn set" do
      @address_book.lookup(sn: "Sugar",
                           gn: "Pierre").should_not be_empty
    end

    it "finds contact with leading and training white spaces in sn and gn" do
      @address_book.lookup(sn: " Sugar ",
                           gn: "   Pierre ").should_not be_empty
    end

    it "ignores capitalized values in sn and gn" do
      @address_book.lookup(sn: " sugar",
                           gn: " pierre \n").should_not be_empty
    end

    it "finds contact if only sn is set" do
      @address_book.lookup(sn: "sugar").should_not be_empty
    end

    it "finds contact with cn = 'Pierre Sugar' set" do
      @address_book.lookup(cn: "Pierre Sugar").should_not be_empty
    end

    it "finds contact with cn = 'Sugar, Pierre' set" do
      @address_book.lookup(cn: "Sugar, Pierre").should_not be_empty
    end

    it "ignores capitalized values in find cn" do
      @address_book.lookup(cn: "pierre Sugar").should_not be_empty
      @address_book.lookup(cn: "sugar, pierre").should_not be_empty
    end

    it "finds contact with cn when only one part of the name is set" do
      @address_book.lookup(cn: "Pierre").should_not be_empty
      @address_book.lookup(cn: "Sugar").size.should eq 2
    end

    it "finds multiple contacts based on attributes other than cn, gn and sn" do
      @address_book.lookup(mail: "amanda@sugar.com").should_not be_empty
    end

    it "find should return nil when no attribute matches" do
      @address_book.lookup(mail: "user@example.com").should be_empty
    end 
  end
end
