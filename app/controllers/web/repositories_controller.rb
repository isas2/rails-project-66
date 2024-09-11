# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories.includes(:checks).order(full_name: :asc)
    end

    def show
      @repository = current_user.repositories.find(params[:id])
    end

    def new
      @repository = current_user.repositories.build
    end

    def create
      github = ApplicationContainer[:github_helper]
      repo_attrs = github.repo_info(current_user, params[:repository][:full_name])
      @repository = current_user.repositories.build(repo_attrs)

      if @repository.save
        CheckCreator.new(@repository).create
        redirect_to repositories_path, notice: t('.success')
      else
        redirect_to new_repository_path,
                    flash: { error: @repository.errors.full_messages.first }
      end
    end
  end
end
