# frozen_string_literal: true

module Api
  class ChecksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      security_helper = ApplicationContainer[:security_helper]
      head :unauthorized unless security_helper.valid_token?(request)

      repository = Repository.find_by(github_id: params[:repository][:id])
      CheckCreator.new(repository).create if repository
      render json: { status: :success }
    end
  end
end
