# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      auth = request.env['omniauth.auth']
      user = User.find_or_initialize_by(email: auth.info['email'].downcase)
      user.nickname = auth.info['nickname']
      user.token = auth['credentials']['token']
      user.save
      sign_in(user) if user.persisted?
      redirect_to root_path, notice: t('.success')
    end

    def delete
      sign_out
      redirect_to root_path, notice: t('.success')
    end
  end
end
