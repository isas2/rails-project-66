# frozen_string_literal: true

class SecurityHelper
  def valid_token?(request)
    secret = ENV.fetch('GITHUB_WEBHOOK_SECRET', nil)
    header_sign = request.headers.fetch('X-Hub-Signature-256', nil)
    valid_sign = "sha256=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, request.body.read)}"
    ActiveSupport::SecurityUtils.secure_compare(header_sign, valid_sign)
  end
end
