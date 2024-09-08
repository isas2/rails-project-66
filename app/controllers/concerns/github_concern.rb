# frozen_string_literal: true

require 'json'

module GithubConcern
  extend ActiveSupport::Concern

  def self.included(base)
    base.helper_method :github_repo_list
  end

  def github_repo_info(link)
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
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

  def github_repo_list
    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true
    repos = client.repos.select do |repo|
      Repository.language.value?(repo.language)
    end
    repos.map(&:full_name).sort
  end
end
