#!/usr/bin/env ruby

require 'optparse'
require 'yaml'
require_relative '../lib/sycontact/address_book_library'

sycontact_directory     = File.expand_path("~/.syc/sycontact")
sycontact_file          = File.join(sycontact_directory, "sycontact.rc")
address_books_directory = File.join(sycontact_directory, "address_books/")

unless File.exist? sycontact_directory
  Dir.mkdir sycontact_directory
end

unless File.exists? address_books_directory
  Dir.mkdir address_books_directory
end

unless File.exists? sycontact_file
  puts "\nsycontact"
  puts "========="
  puts "You have to add the address source file directory to #{sycontact_file}"
  puts "Look at the README.md to see how to configure sycontact\n"
  config = { address_books: [ ] }
  File.open(sycontact_file, 'w') { |f| YAML.dump(config, f) }
  ARGV << "-h"
else
  config = YAML.load_file(sycontact_file)
  address_books = config[:address_books]
  if address_books.empty?
    puts "\nsycontact"
    puts "========="
    puts "You have to add the address source file directory to #{sycontact_file}\n\n"
    ARGV << "-h"
  end
end

options = {} 

option_parser = OptionParser.new do |opts|

  opts.on("-n", "--cn COMMON_NAME", "Common name e.g. 'Jane Doe' or 'Doe, Jane'") do |common_name|
    options[:cn] = common_name
  end

  opts.on("-s", "--sn SURNAME", "Surname e.g. 'Doe'") do |surname|
    options[:sn] = surname
  end

  opts.on("-g", "--gn GIVEN_NAME", "Given name e.g. 'Jane'") do |given_name|
    options[:gn] = given_name
  end

  opts.on("-c COUNTRY", "Country in ISO 3166 e.g. 'CA' for Canada") do |country|
    options[:c] = country
  end

  opts.on("-l LOCATION", "City e.g. 'Vancouver'") do |location|
    options[:l] = location
  end

  opts.on("-t", "--st STATE", "State e.g. 'British Columbia'") do |state|
    options[:st] = state
  end

  opts.on("-r", "--street STREET", "Street e.g. 'Robson Street'") do |street|
    options[:street] = street
  end

  opts.on("-o ORGANIZATION", "Organization e.g. 'Northstar'") do |organization|
    options[:organization] = organization
  end

  opts.on("-u", "--ou ORGANIZATIONAL_UNIT", "Department e.g. 'R&D'") do |organizational_unit|
    options[:ou] = organizational_unit
  end

  opts.on("-i", "--title TITLE", "Title e.g. 'Dr.'") do |title|
    options[:title] = title
  end

  opts.on("-d", "--description DESCRIPTION", "Description e.g. 'Head of R&D'") do |description|
    options[:descripton] = description
  end

  opts.on("-p", "--telephone TELEPHONE", "Telephone number e.g. '+001 (252) 4354'") do |telephone|
    options[:telephone] = telephone
  end

  opts.on("-m", "--mobile MOBILE_PHONE", "Mobile number e.g. '+001 (252) 4345'") do |mobile_phone|
    options[:mobile] = mobile_phone
  end

  opts.on("-a", "--mail E-MAIL", "E-Mail address e.g. 'jane@northstart.ca'") do |email|
    options[:mail] = email
  end

  opts.on("-h", "--help", "Show his message") do
    puts opts
    exit(0)
  end
end

begin
  option_parser.parse!
rescue OptionParser::ParseError => e
  STDERR.puts e.message, "\n", options
  exit(1)
end

library = Sycontact::AddressBookLibrary.new(address_books[0])
puts library.lookup(options)
