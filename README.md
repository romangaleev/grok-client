OpenGrok client
===============
```
Usage: 
$ ./grok.pl search_term
$ HTTPS_CA_FILE=gooddata.pem ./grok.pl search_term
$ HTTPS_CA_FILE=gooddata.pem USER=username PASSWORD=password ./grok.pl search_term
```

Setup
=====
Check required packages are installed:
```
./check-config.pl
```
Install missing packages:
```
$ cpanm Web::Scraper
$ cpanm LWP::Protocol::https
```
To use Kerberos authentication just do:
```
$ cpanm LWP::Authen::Negotiate 
```
Bug: when LWP::Authen::Negotiate is installed basic auth doesn't work.

Notes
=====
Ubuntu 12.04 contains buggy Net::HTTP package. Here is how to upgrade:
```
$ curl -L https://cpanmin.us | perl - App::cpanminus
$ cpanm Net::HTTP
```
Link to the bug report: https://rt.cpan.org/Public/Bug/Display.html?id=80670
