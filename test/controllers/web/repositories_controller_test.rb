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
    stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
      .to_return(status: 200,
                 body: load_fixture('files/resp_repo_list.json'),
                 headers: { 'Content-Type' => 'application/json' })

    get new_repository_url
    assert_response :success
  end

  test 'should create repository' do
    repo_name = 'isas2/hexlet-assignments'
    stub_request(:get, "https://api.github.com/repos/#{repo_name}")
      .to_return(status: 200,
                 body: load_fixture('files/resp_repo_info.json'),
                 headers: { 'Content-Type' => 'application/json' })

    assert_difference('Repository.count') do
      post repositories_url, params: { repository: { full_name: repo_name } }
    end
    repository = Repository.last
    assert_equal repository.name, 'Hello-World'
  end
end
