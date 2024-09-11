# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
    sign_in users(:one)
  end

  test 'should get index' do
    get repositories_url
    assert_response :success
  end

  test 'should show repository' do
    get repository_url(@repository)
    assert_response :success
  end

  test 'should get new' do
    get new_repository_url
    assert_response :success
  end

  test 'should create repository' do
    repo_name = 'isas2/hexlet-assignments'
    assert_difference('Repository.count') do
      post repositories_url, params: { repository: { full_name: repo_name } }
    end
    assert_equal Repository.last.name, 'Hello-World'
  end
end
