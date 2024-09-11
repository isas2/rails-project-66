# frozen_string_literal: true

class GithubHelper
  def repo_info(user, link)
    client = Octokit::Client.new access_token: user.token, auto_paginate: true
    repo = Octokit::Repository.from_url("/#{link}")
    data = client.repository(repo)
    {
      name: data[:name],
      github_id: data[:id],
      full_name: data[:full_name],
      language: data[:language],
      clone_url: data[:clone_url],
      ssh_url: data[:ssh_url]
    }
  end

  def repo_list(user)
    client = Octokit::Client.new access_token: user.token, auto_paginate: true
    repos = client.repos.select do |repo|
      Repository.language.value?(repo.language)
    end
    repos.map(&:full_name).sort
  end
end
