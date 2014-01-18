require_relative 'address_book'

# sycontac module providing functions to lookup contacts
module Sycontact

  # AddressBookLibrary creates AddressBook objects and forwards all messages invoked on 
  # AddressBookLibrary to all AddressBooks.
  class AddressBookLibrary

    # The contacts from the last lookup invocation
    attr_reader :contacts

    # Creates AddressBook objects based on the address book source files contained in the
    # address_book_directory
    def initialize(address_book_directory)
      @address_books = []
      Dir.glob(File.join(address_book_directory, "*_source.rb")).each do |address_book|
        @address_books << AddressBook.new(address_book)
      end
    end

    # Looks up a contact based on the pattern and returns the contact data as a hash. The contact
    # data can subsequentially retrievied with :contacts
    def lookup(pattern = {})
      @contacts = {}
      @address_books.each do |address_book|
        puts "\n#{address_book.title}\n"
        @contacts[address_book.title] = address_book.lookup(pattern)
      end
      @contacts
    end

    # Invokes a lookup on all AddressBook objects and prints the result to the console with all
    # attributes found in the contact source
    def print_all(pattern = {})
      @address_books.each do |address_book|
        puts "\n#{address_book.title}"
        address_book.lookup(pattern).each do |contact|
          address_book.print_all(contact)
        end
      end
    end

    # Invokes a lookup on all AddressBook objects and prints a subset of the result to the console.
    # The attributes that are selected for print are defined in AddressBook::SUMMARY
    def print_summary(pattern = {})
      @address_books.each do |address_book|
        puts "\n#{address_book.title}"
        address_book.lookup(pattern).each do |contact|
          address_book.print_summary(contact)
        end
      end
    end

  end

end
