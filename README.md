sycontact
=========
`syc-ontact` is a command line interface for looking up contacts from any source that is providing contact information.

Installation
============
`gem install sycontact`

Setup
=====
To use `sycontact` a source-file has to be provided. The source-file is Ruby script retrieving the data from the source. A source can be anything that can be read from the Ruby script, e.g. a web site, an LDAP server, a file with contact data.

**Note:** Without a user defined Ruby script file (a Ruby module) `sycontact` will do nothing but 
          creating a configuration file, a source directory and displaying the help page.

To get `sycontact` to life you have to follow these setup steps:

1. start  `sycontact` once. This will create the configuration file and the working directory
2. provide a Ruby module describing how to retrieve the data from the source. The module name has
   to be `some_name_source.rb`.

The Ruby source code below describes a source-file that is retrieving contact data from a contact directory with the name *test-contacts* below the module's directory.


```
module AddressSource

  # Where to find the contact files
  URL = File.join(File.dirname(__FILE__), "test-contacts")

  # Regex to extract contact data from the contact files
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

  # Mandatory method! Will be invoked by `sycontact`.
  # Will lookup the contact based on the pattern provided
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

  private

    # Creates the contact file name. In this case the contact files have to be in the form
    # firstname_lastname.contact or lastname_firstname.contact. If neather is given all *_*.contact
    # files are retrieved
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
```

**Listing 1: Source-file to provide information about how to retrieve contact information**

Below a contact file that can be read by the above source module.

```
<common_name>Sugar Pierre</common_name>
<given_name>Pierre</given_name>
<surname>Sugar</surname>
<country>CA</country>
<location>Vancouver</location>
<state>BC</state>
<street>Robson Street</street>
<organization>SugarYourCoffee</organization>
<department>DevOps</department>
<telephone>+001 (123) 4567</telephone>
<mobile>+001 (765) 4321</mobile>
<email>pierre@sugaryourcoffee.de</email>
```

**Listing 2: Contact file that can be read by the `AddressSource` module**

Usage
=====

Get help for sycontact

    $ sycontact -h

```
Usage: sycontact [options]
    -p, --print RAW|SUMMARY|ALL      Print contact attributes
                                     SUMMARY (default)
        --cn COMMON_NAME             Common name e.g. 'Jane Doe' or 'Doe, Jane'
        --sn SURNAME                 Surname e.g. 'Doe'
        --gn GIVEN_NAME              Given name e.g. 'Jane'
        --uid USER_ID                User ID
    -c COUNTRY                       Country in ISO 3166 e.g. 'CA' for Canada
    -l LOCATION                      City e.g. 'Vancouver'
        --st STATE                   State e.g. 'British Columbia'
        --street STREET              Street e.g. 'Robson Street'
    -o ORGANIZATION                  Organization e.g. 'Northstar'
        --ou ORGANIZATIONAL_UNIT     Department e.g. 'R&D'
        --title TITLE                Title e.g. 'Dr.'
        --description DESCRIPTION    Description e.g. 'Head of R&D'
        --telephone TELEPHONE        Telephone number e.g. '+001 (252) 4354'
        --mobile MOBILE_PHONE        Mobile number e.g. '+001 (252) 4345'
        --mail E-MAIL                E-Mail address e.g. 'jane@northstart.ca'
    -h, --help                       Show his message
```

Lookup a contact with summary output

    $ sycontact --cn sugar
    $ sycontact --cn "sugar, pierre"
    $ sycontact --cn "pierre sugar"

Any of the above commands result in the following output

```
AddressSource

CN..................Sugar Pierre
C...................DE
L...................Vancouver
O...................SugarYourCoffee
OU..................DevOps
TELEPHONE...........+001 (123) 4567
MOBILE..............+001 (765) 4321
MAIL................pierre@sugaryourcoffee.de
```
Sources
=======
Home page: <http://syc.dyndns.org/drupal/wiki/sycontact-lookup-contacts-any-source>
Source:    <https://github.com/sugaryourcoffee/sycontact

Contact
=======
<mailto: pierre@sugaryourcoffee.de>
