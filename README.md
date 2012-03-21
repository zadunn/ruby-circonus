#ruby-circonus

Forked from Adam Jacob (https://github.com/adamhjk/ruby-circonus) 

Major Differences:

* No support for older style email/password auth.  Instead, we only support tokens and app names.  
* No defined methods, e.g. list_checks, instead we have a very generic wrapper that you pass an endpoint too.  This has the advantage of making the code simpler, as well as future proofing against the addition of new endpoints.


##Before You Begin 

Before you do anything make sure you have an API token, and an allowed app name.  To create and manage these go to https://circonus.com/user/tokens .

##How to Use

### Active Record Style

    require "ruby-circonus" 

    request = Circonus.new('*MyToken*', '*MyAppName*', '*MyAccount*')

    request.call(:method => 'get', :endpoint => "list_checks" )

This will return parsed JSON.

The circonus API will, at times, request additional params or you will want to pass the optional ones.  In order to do to this just add whatever value you need into the hash.  

Examples:

### List Metrics

    request.call("method" => "get", "endpoint" => "list_metrics", "check_id" => "7715")

### List Alerts

    request.call(:method => 'get', :endpoint => "list_alerts", :account => "omniti", :start => "2012-03-20 00:00:00 EST", :end => "2012-03-21 23:59:00 EST", :cleared => "0")
