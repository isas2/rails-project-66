# frozen_string_literal: true

class RepositoryUpdateJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find_by(id: repository_id)
    github = ApplicationContainer[:github_helper].new(repository.user)
    repo_attrs = github.repo_info(repository.github_id)
    repository.update(repo_attrs)
    github.new_repo_hook(repository)
  end
end
