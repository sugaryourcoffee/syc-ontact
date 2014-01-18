module AddressSource

  URL = File.join(File.dirname(__FILE__), "test-contacts")

  REGEX = { cn: /(?<=<common_name>)[\w -]*(?=<\common_name>)/,
            sn: /(?<=<surname>)[\w -]*(?=<\/surname>)/,
            gn: /(?<=<given_name>)[\w -]*(?=<\/given_name>)/,
            c: /(?<=<country>)[\w]*(?=<\/country>)/,
            l: /(?<=<location>)[\w]*(?=<\/location>)/,
            st: /(?<=<state>)[\w]*(?=<\/state>)/,
            street: /(?<=<street>)[\w .]*(?=<\/street>)/,
            o: /(?<=<organization>)[\w -]*(?=<\/organization>)/,
            ou: /(?<=<department>)[\w -]*(?=<\/department>)/,
            title: /(?<=<title>)[\w .-]*(?=<\/title>)/,
            description: /(?<=<description>)[\w -+]*(?=<\/description>)/,
            telephone: /(?<=<telephone>)[\w +()-]*(?=<\/telephone>)/,
            mobile: /(?<=<mobile>)[\w +()-]*(?=<\/mobile>)/,
            mail: /(?<=<email>)[\w @.-]*(?=<\/email>)/
          }

  def lookup(pattern = {})
    contacts = []
    create_source_files(pattern).each do |source_file|

      next unless File.exist? source_file

      source = File.read(source_file)

      next if source.empty?

      values = {}

      REGEX.each do |key, regex|
        value = source.scan(regex)[0]
        values[key] = value if value
      end

      contacts << values
    end

    contacts.keep_if do |contact|
      pattern.each.reduce(true) do |match, pattern| 
        contact_does_not_have_key = contact[pattern[0]].nil?
        regex = Regexp.new(pattern[1].strip.downcase)
        pos = regex =~ contact[pattern[0]].strip.downcase unless contact_does_not_have_key
        match and (not pos.nil? or contact_does_not_have_key)
      end
    end
  end

=begin
  def title
    "Test-Address-Book"
  end
=end

  private

    def create_source_files(pattern)
      source_files = []
      if pattern[:cn]
        names = pattern[:cn].scan(/(^[a-zA-Z]*)[^a-zA-Z]*([a-zA-Z]*)/).flatten
        names[0] = '*' if names[0].empty?
        names[1] = '*' if names[1].empty?
        names.permutation do |names|
          file = File.join(URL, "#{names.join('_').downcase}.contact")
          Dir.glob(file).each { |file| source_files << file }
        end
      elsif pattern[:sn] or pattern[:gn]
        sn = pattern[:sn] ? pattern[:sn].strip.downcase : '*'
        gn = pattern[:gn] ? pattern[:gn].strip.downcase : '*'
        Dir.glob(File.join(URL, "#{gn}_#{sn}.contact")).each do |file|
          source_files << file
        end
      else
        Dir.glob(File.join(URL, "*_*.contact")).each do |file|
          source_files << file
        end
      end
      source_files
    end
end
