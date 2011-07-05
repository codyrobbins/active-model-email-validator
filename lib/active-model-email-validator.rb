# encoding: UTF-8

require('mail')

# This is a simple ActiveModel validator for email addresses built on top of the [Mail gem](http://rubygems.org/gems/mail). Instead of trying to devise an overly complex custom (and probably incorrect) regular expression to validate email addresses that is compliant with RFC 5321/5322—a difficult task—it instead relies on the Mail gem to parse the address. Since the Mail gem is an actively maintained library for working with email, if it can’t deal with an address it’s probably not worth attempting to send to anyways.
#
# An additional check is performed to ensure that the domain name in the address has at least two components—that is, a top-level domain and one subdomain. The validator purposefully errs on the side of inclusivity rather than exclusivity: it might allow some invalid email addresses, but it hopefully doesn’t disallow valid addresses.
#
# Example
# -------
#
# The following model uses `ActiveModel::Validations::PresenceValidator` and `ActiveRecord::Validations::UniquenessValidator` to ensure the presence and uniqueness of the user’s email attribute. The third line uses `EmailValidator` to check that the email address is valid.
#
#     class User < ActiveRecord::Base
#       validates(:email,
#                 :presence   => {:message => "Email can't be blank"},
#                 :uniqueness => {:message => 'Email must be unique'},
#                 :email      => {:message => 'Email must be valid'})
#     end
class EmailValidator < ActiveModel::EachValidator
  # The interface that `ActiveModel::Validations` uses to invoke the validation. This method is not called directly.
  def validate_each(object, attribute, value)
    add_error_to(object, attribute) unless valid?(value)
  end

  protected

  def valid?(value)
    # Allow blank values to pass through.
    return(true) if value.blank?

    # Disallow unparseable addresses.
    begin
      parse_address(value)
    rescue unparseable_address
      return(false)
    end

    # Make sure the domain in the address is reasonable.
    domain_present? && domain_has_more_than_one_component?
  end

  def add_error_to(object, attribute)
    object.errors.add(attribute, error_message)
  end

  def error_message
    options[:message] || :email
  end

  def parse_address(value)
    @address = Mail::Address.new(value)
  end

  def unparseable_address
    Mail::Field::ParseError
  end

  def domain_present?
    @address.domain.present?
  end

  def domain_has_more_than_one_component?
    @address.send(:tree).domain.dot_atom_text.elements.size > 1
  end
end

require('active_support/i18n')
I18n.load_path << File.dirname(__FILE__) + '/email_validator/locale/en.yml'
