module Sycontact

  class AddressBook
  
    SUMMARY = [ :cn, :c, :l, :o, :ou, :telephone, :mobile, :mail ]

    def initialize(source)
      source = source.sub('.rb', '')
      require source
      @module_name = pascalize(File.basename(source))
      extend self.class.module_eval(@module_name)
    end

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

      def pascalize(string)
        (string.split('_').map { |word| word.capitalize }).join
      end
  end
end
