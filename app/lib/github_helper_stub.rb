# frozen_string_literal: true

class GithubHelperStub
  def initialize(*); end

  def repo_info(github_id)
    data = JSON.parse(Rails.root.join('test/fixtures/files/repo_info.json').read)
    data.merge(github_id:)
  end

  def repo_list
    JSON.parse(Rails.root.join('test/fixtures/files/repo_list.json').read)
  end

  def new_repo_hook(_repo); end

  def self.valid_token?(_request)
    true
  end
end
