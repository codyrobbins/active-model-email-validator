Active Model Email Validator
============================

This is a simple ActiveModel validator for email addresses built on top of the [Mail gem](http://rubygems.org/gems/mail). Instead of trying to devise an overly complex custom (and probably incorrect) regular expression to validate email addresses that is compliant with RFC 5321/5322—a difficult task—it instead relies on the Mail gem to parse the address. Since the Mail gem is an actively maintained library for working with email, if it can’t deal with an address it’s probably not worth attempting to send to anyways.

An additional check is performed to ensure that the domain name in the address has at least two components—that is, a top-level domain and one subdomain. The validator purposefully errs on the side of inclusivity rather than exclusivity: it might allow some invalid email addresses, but it hopefully doesn’t disallow valid addresses.

Full documentation is at [RubyDoc.info](http://rubydoc.info/gems/active-model-email-validator).

Example
-------

The following model uses `ActiveModel::Validations::PresenceValidator` and `ActiveRecord::Validations::UniquenessValidator` to ensure the presence and uniqueness of the user’s email attribute. The third line uses `EmailValidator` to check that the email address is valid.

    class User < ActiveRecord::Base
      validates(:email,
                :presence   => {:message => "Email can't be blank"},
                :uniqueness => {:message => 'Email must be unique'},
                :email      => {:message => 'Email must be valid'})
    end

Note
----

Currently there isn’t a `validates_email` class-level helper method because I’ve never had the need for it in practice, but I may add one at some point.

Colophon
--------

### See also

If you like this gem, you may also want to check out [Static Model](http://codyrobbins.com/software/static-model), [HTTP Error](http://codyrobbins.com/software/http-error), or [Email Test Helpers](http://codyrobbins.com/software/email-test-helpers).

### Tested with

* ActiveModel 3.0.5 — 20 May 2011

### Contributing

* [Source](https://github.com/codyrobbins/active-model-email-validator)
* [Bug reports](https://github.com/codyrobbins/active-model-email-validator/issues)

To send patches, please fork on GitHub and submit a pull request.

### Credits

© 2011 [Cody Robbins](http://codyrobbins.com/). See LICENSE for details.

* [Homepage](http://codyrobbins.com/software/active-model-email-validator)
* [My other gems](http://codyrobbins.com/software#gems)
* [Follow me on Twitter](http://twitter.com/codyrobbins)