# frozen_string_literal: true

class CheckCreator
  def initialize(repository)
    @repository = repository
  end

  def create
    check = @repository.checks.build
    check.start! if check.save && check.may_start?
    check
  end
end
