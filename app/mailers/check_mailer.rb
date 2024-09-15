# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  def check_error_email
    @check = params[:check]
    mail(to: @check.repository.user.email, subject: t('.title'))
  end
end
