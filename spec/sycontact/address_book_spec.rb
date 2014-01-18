require 'sycontact/address_book'

# sycontac module providing functions to lookup contacts
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

    it "should return title" do
      @address_book.title.should eq "AddressSource"
    end

    it "should return print summary of result" do
      output = []
      @address_book.lookup(cn: "Pierre Sugar").each do |contact|
       @address_book.print_summary(contact) do |k, v|
          output << "#{k} has the value of #{v}"
        end
      end
      output.should eq [
        "sn has the value of Sugar", 
        "gn has the value of Pierre", 
        "c has the value of DE", 
        "l has the value of Vancouver", 
        "st has the value of BC", 
        "street has the value of Robson Street", 
        "o has the value of SugarYourCoffee", 
        "ou has the value of DevOps", 
        "title has the value of No Title", 
        "description has the value of Development and Operations", 
        "telephone has the value of +001 (123) 4567", 
        "mobile has the value of +001 (765) 4321", 
        "mail has the value of pierre@sugaryourcoffee.de"
      ]
    end

    it "should print all of result" do
      output = []
      @address_book.lookup(cn: "Pierre Sugar").each do |contact|
        output << @address_book.print_all(contact)
      end
      output.should eq [
        [{:sn=>"Sugar", 
          :gn=>"Pierre", 
          :c=>"DE", 
          :l=>"Vancouver", 
          :st=>"BC", 
          :street=>"Robson Street", 
          :o=>"SugarYourCoffee", 
          :ou=>"DevOps", 
          :title=>"No Title", 
          :description=>"Development and Operations", 
          :telephone=>"+001 (123) 4567", 
          :mobile=>"+001 (765) 4321", 
          :mail=>"pierre@sugaryourcoffee.de"}]
      ]
    end
  end
end
