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

