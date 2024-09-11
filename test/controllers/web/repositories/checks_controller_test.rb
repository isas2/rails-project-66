# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'should create check' do
    repo = repositories(:one)
    assert_difference('Repository::Check.count') do
      post repository_checks_url(repo.id), params: { repository_id: repo.id }
    end

    assert_redirected_to repository_url(repo.id)
  end

  test 'should show check' do
    check = repository_checks(:one)
    get repository_check_url(check.repository_id, check)
    assert_response :success
  end
end
