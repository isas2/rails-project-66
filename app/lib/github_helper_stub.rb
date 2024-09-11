# frozen_string_literal: true

class GithubHelperStub
  def repo_info(_, _)
    JSON.parse(Rails.root.join('test/fixtures/files/repo_info.json').read)
  end

  def repo_list(_)
    JSON.parse(Rails.root.join('test/fixtures/files/repo_list.json').read)
  end
end
