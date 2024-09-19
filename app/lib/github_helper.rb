# frozen_string_literal: true

class GithubHelper
  def repo_info(repo)
    data = client(repo.user).repo(repo.github_id.to_i)
    {
      name: data[:name],
      github_id: data[:id].to_s,
      full_name: data[:full_name],
      language: data[:language]&.downcase,
      clone_url: data[:clone_url],
      ssh_url: data[:ssh_url]
    }
  end

  def repo_list(user)
    Rails.cache.fetch('github_repo_list', expires_in: 30.minutes) do
      repos = client(user).repos.select do |repo|
        repo[:language] && Repository.language.value?(repo[:language].downcase)
      end
      repos.map { |repo| [repo[:full_name], repo[:id]] }.sort
    end
  end

  def new_repo_hook(repo)
    client(repo.user).create_hook(
      repo.full_name,
      'web',
      {
        url: Rails.application.routes.url_helpers.api_checks_url,
        content_type: 'json',
        secret: ENV.fetch('GITHUB_WEBHOOK_SECRET', nil)
      }
    )
  end

  private

  def client(user)
    ApplicationContainer[:octokit].new access_token: user.token, auto_paginate: true
  end
end
