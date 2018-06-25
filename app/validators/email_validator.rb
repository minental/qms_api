class EmailValidator < ActiveModel::EachValidator
  VALID_EMAIL_REGEX = /\A.+@.+\..+\z/

  def validate_each(record, _attribute, value)
    if value.present?
      record.errors['email'] << (options[:message] || 'is invalid format') unless VALID_EMAIL_REGEX.match?(value)
    end
  end
end
