# frozen_string_literal: true

module Api
  class ChecksController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :check_security_token

    def create
      repository = Repository.find_by(github_id: params[:repository][:id])
      CheckCreator.new(repository).create if repository
      render json: { status: :success }
    end

    private

    def check_security_token
      github = ApplicationContainer[:github_helper]
      head :unauthorized unless github.valid_token?(request)
    end
  end
end
