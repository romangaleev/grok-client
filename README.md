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

Notes
=====
Ubuntu 12.04 contains buggy Net::HTTP package. Here is how to upgrade:
```
$ curl -L https://cpanmin.us | perl - App::cpanminus
$ cpanm Net::HTTP
```
Link to the bug report: https://rt.cpan.org/Public/Bug/Display.html?id=80670

UA.pm contains patched version of LWP::UserAgent->request() method to allow
fallback to basic auth scheme if negotiation fails.

Link to the pull request: https://github.com/libwww-perl/libwww-perl/pull/78
