# frozen_string_literal: true

module Web
  class Repositories::ChecksController < ApplicationController
    before_action :authenticate_user!

    def show
      repository = current_user.repositories.find(params[:repository_id])
      @check = repository.checks.find(params[:id])
      @error_count = CheckReportHelper.error_count(@check)
      @error_report = CheckReportHelper.report(@check)
    end

    def create
      repository = current_user.repositories.find(params[:repository_id])

      if CheckCreator.new(repository).create
        redirect_to repository_path(repository), notice: t('.success')
      else
        redirect_to repository_path(repository), flash: { error: t('.error') }
      end
    end
  end
end
