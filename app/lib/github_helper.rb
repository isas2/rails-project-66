# frozen_string_literal: true

class GithubHelper
  attr_reader :client

  def initialize(user)
    @client = Octokit::Client.new access_token: user.token, auto_paginate: true
  end

  def repo_info(github_id)
    data = client.repo(github_id.to_i)
    {
      name: data[:name],
      github_id: data[:id].to_s,
      full_name: data[:full_name],
      language: data[:language].downcase,
      clone_url: data[:clone_url],
      ssh_url: data[:ssh_url]
    }
  end

  def repo_list
    Rails.cache.fetch('github_repo_list', expires_in: 30.minutes) do
      repos = client.repos.select do |repo|
        repo.language && Repository.language.value?(repo.language.downcase)
      end
      repos.map { |repo| [repo.full_name, repo.id] }.sort
    end
  end

  def new_repo_hook(repo)
    client.create_hook(
      repo.full_name,
      'web',
      {
        url: Rails.application.routes.url_helpers.api_checks_url,
        content_type: 'json',
        secret: ENV.fetch('GITHUB_WEBHOOK_SECRET', nil)
      }
    )
  end

  def self.valid_token?(request)
    secret = ENV.fetch('GITHUB_WEBHOOK_SECRET', nil)
    header_sign = request.headers.fetch('X-Hub-Signature-256', nil)
    valid_sign = "sha256=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, request.body.read)}"
    ActiveSupport::SecurityUtils.secure_compare(header_sign, valid_sign)
  end
end
