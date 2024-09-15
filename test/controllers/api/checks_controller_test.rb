# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test 'api should create check' do
    repo = repositories(:one)
    perform_enqueued_jobs do
      assert_difference('Repository::Check.count') do
        post api_checks_url, params: { repository: { id: repo.github_id }, format: :json }
      end
    end

    assert_equal repo.checks.last.result, true
  end
end
