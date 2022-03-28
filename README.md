# read_ipa [![Build Status](https://travis-ci.org/playtestcloud/read_ipa.png?branch=master)](https://travis-ci.org/playtestcloud/read_ipa) [![Gem Version](https://badge.fury.io/rb/read_ipa.png)](http://badge.fury.io/rb/read_ipa)

Reads metadata form iPhone Package Archive Files (ipa).

## USAGE

```bash
irb > require 'rubygems'
 => true
irb > require 'read_ipa'
 => true
irb > ipa_file = ReadIpa::IpaFile.new("/path/to/file.ipa")
 => #<ReadIpa::IpaFile:0x1012a9458>
irb > ipa_file.version
 => "1.2.2.4"
irb > ipa_file.name
 => "MultiG"
irb > ipa_file.target_os_version
 => "4.1"
irb > ipa_file.minimum_os_version
 => "3.1"
irb > ipa_file.url_schemes
 => []
irb > ipa_file.bundle_identifier
 => "com.dcrails.multig"
irb > ipa_file.icon_prerendered
 => false
irb > ipa_file.get_property('CFBundleDisplayName')
 => "MultiG"
```

## Supported ruby versions

* \>= 2.3.0
* \>= 3.0.0

## INSTALL

`gem install read_ipa`

## Contributors

* [@schlu](//github.com/schlu)
* [@yayanet](//github.com/yayanet)
* [@mwhuss](//github.com/mwhuss)

## LICENSE

(The MIT License)

Copyright (c) 2010

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
