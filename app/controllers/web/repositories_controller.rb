# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    include GithubConcern
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories
    end

    def show
      @repository = current_user.repositories.find(params[:id])
    end

    def new
      @repository = current_user.repositories.build
    end

    def create
      repo_attrs = github_repo_info(repository_params['full_name'])
      @repository = current_user.repositories.build(repo_attrs)

      if @repository.save
        redirect_to repository_url(@repository), notice: t('.success')
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:full_name)
    end
  end
end
