# sycontac module providing functions to lookup contacts
module Sycontact

  # AddressBook is a wrapper for source modules that contain a script for retrieving contact data
  # from a source as Internet, LDAP server or a file
  class AddressBook
  
    # Holds the values that are used when printing the summary of a contact
    SUMMARY = [ :cn, :c, :l, :o, :ou, :telephone, :mobile, :mail ]

    # Creates a new AddressBook. It requires the source module file and extends AddressBook with
    # the source module
    def initialize(source)
      source = source.sub('.rb', '')
      require source
      @module_name = pascalize(File.basename(source))
      extend self.class.module_eval(@module_name)
    end

    # The source module can override the address source title, print_summary and print_all methods.
    # If the methods are not overridden the default methods are invoked. The source module has to
    # provide a lookup method. If the lookup method is not available "method missing" will be
    # thrown
    def method_missing(method, *args, &block)
      case method
      when :title
        @module_name
      when :print_summary
        args.each do |contact|
          puts "\n"
          contact.each do |k,v|
            if block_given?
              yield(k, v)
            else
              unless SUMMARY.index(k).nil?
                puts "#{k.to_s.upcase.ljust(20, '.')}#{v}\n" unless v.nil? or v.empty?
              end
            end
          end
        end
      when :print_all
        args.each do |contact|
          puts "\n"
          contact.each do |k,v|
            if block_given?
              yield(k, v)
            else
              puts "#{k.to_s.upcase.ljust(20, '.')}#{v}\n" unless v.nil? or v.empty?
            end
          end
        end
      else
        super
      end 
    end

    private

      # Pascalizes/camalizes a string as address_source to AddressSource
      def pascalize(string)
        (string.split('_').map { |word| word.capitalize }).join
      end
  end
end
