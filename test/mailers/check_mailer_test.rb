# frozen_string_literal: true

require 'test_helper'

class CheckMailerTest < ActionMailer::TestCase
  test 'new check email' do
    check = repository_checks(:one)
    mail = CheckMailer.with(check:).check_error_email
    assert_equal check.repository.user.email, mail.to.first
  end
end
