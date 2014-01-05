syc-ontact
==========
`syc-ontact` is a command line interface for looking up contacts from any source that is providing contact information and where the interface can be described in a key value pair like interface.

Installation
============
`gem install syc-ontact`

Usage
=====
To use `syc-ontact` a source-file has to be provided in the form of

```
address,<http://where-to-lookup-contacts>
attribute,start-pattern,end-pattern
```

**Listing 1: Source-file to provide information about how to retrieve contact information**

Example
-------

|Attributes  |Start-Pattern     |End-Pattern|
|------------|------------------|-----------|
|name        |<name>            |</name>    |
|organization|<org>             |</org>     |
|phone       |<phone>           |</phone>   |

**Table 1: Source-file describing how to obtain information from the source**

Home page: <http://syc.dyndns.org/drupal/wiki/sycontact-lookup-contacts-any-source>

Contact
=======
<mailto: pierre@sugaryourcoffee.de>
