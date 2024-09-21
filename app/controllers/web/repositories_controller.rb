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
      @repository = current_user.repositories.build(github_id: params[:repository][:github_id])

      if @repository.save
        RepositoryUpdateJob.perform_later(@repository.id)
        redirect_to repositories_path, notice: t('.success')
      else
        render :new, status: :unprocessable_entity
      end
    end
  end
end
