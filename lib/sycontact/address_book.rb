
module Sycontact

  class AddressBook
  
    attr_reader :url, :url_type, :patterns

    def initialize(source)
      @patterns = {}
      File.open(source, 'r') do |file|
        @url_type, @url = file.readline.scan(/(^\w*|(?<=,).*$)/).flatten
        file.readlines.each do |line|
          key, regex = line.scan(/(^\w*|(?<=,).*$)/).flatten
          @patterns[key] = Regexp.new regex unless key.empty?
        end
      end
    end

    def lookup(search = {})

    end
  end
end
