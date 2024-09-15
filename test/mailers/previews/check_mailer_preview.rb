# frozen_string_literal: true

class CheckMailerPreview < ActionMailer::Preview
  def check_error_email
    check = Repository::Check.last
    CheckMailer.with(check:).check_error_email
  end
end
