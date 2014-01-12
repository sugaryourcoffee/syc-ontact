require_relative 'address_book'

module Sycontact

  class AddressBookLibrary

    attr_reader :contacts

    def initialize(address_book_directory)
      @address_books = []
      Dir.glob(File.join(address_book_directory, "*_source.rb")).each do |address_book|
        @address_books << AddressBook.new(address_book)
      end
    end

    def lookup(pattern = {})
      @contacts = {}
      @address_books.each do |address_book|
        @contacts[address_book.title] = address_book.lookup(pattern)
      end
      @contacts
    end

  end

end
