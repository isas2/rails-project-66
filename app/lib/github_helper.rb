# frozen_string_literal: true

class GithubHelper
  attr_reader :client, :user_id

  def initialize(user)
    @user_id = user.id
    @client = ApplicationContainer[:octokit].new access_token: user.token, auto_paginate: true
  end

  def repo_info(github_id)
    data = client.repo(github_id.to_i)
    {
      name: data[:name],
      github_id: data[:id].to_s,
      full_name: data[:full_name],
      language: data[:language]&.downcase,
      clone_url: data[:clone_url],
      ssh_url: data[:ssh_url]
    }
  end

  def repo_list
    Rails.cache.fetch("github_repo_list_#{user_id}", expires_in: 30.minutes) do
      repos = client.repos.select do |repo|
        repo[:language] && Repository.language.value?(repo[:language].downcase)
      end
      repos.map { |repo| [repo[:full_name], repo[:id]] }.sort
    end
  end

  def new_repo_hook(full_name)
    client.create_hook(
      full_name,
      'web',
      {
        url: Rails.application.routes.url_helpers.api_checks_url,
        content_type: 'json',
        secret: ENV.fetch('GITHUB_WEBHOOK_SECRET', nil)
      }
    )
  end

  def self.commit_link(check)
    "https://github.com/#{check.repository.full_name}/commit/#{check.commit_id}"
  end

  def self.file_link(check, path)
    "https://github.com/#{check.repository.full_name}/tree/#{check.commit_id}/#{path}"
  end
end
