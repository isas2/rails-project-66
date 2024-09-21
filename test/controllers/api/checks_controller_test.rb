# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'api should create check' do
    repo = repositories(:one)
    assert_difference('Repository::Check.count') do
      post api_checks_url, params: { repository: { id: repo.github_id }, format: :json }
    end

    assert_equal repo.checks.last.passed, true
  end
end
