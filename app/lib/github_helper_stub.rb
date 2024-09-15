# frozen_string_literal: true

class GithubHelperStub
  def initialize(*); end

  def repo_info(_repo)
    JSON.parse(Rails.root.join('test/fixtures/files/repo_info.json').read)
  end

  def repo_list
    JSON.parse(Rails.root.join('test/fixtures/files/repo_list.json').read)
  end

  def new_repo_hook(_repo); end

  def self.valid_token?(_request)
    true
  end
end
