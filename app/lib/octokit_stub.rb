# frozen_string_literal: true

class OctokitStub
  def initialize(*); end

  def create_hook(*); end

  def repos
    JSON.parse(Rails.root.join('test/fixtures/files/octokit_repos.json').read)
  end

  def repo(id)
    data = JSON.parse(Rails.root.join('test/fixtures/files/octokit_repo.json').read)
    data.merge(id:).transform_keys(&:to_sym)
  end
end
