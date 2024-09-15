# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register(:command_helper, memoize: true) { CommandHelperStub.new }
    register(:github_helper, memoize: true) { GithubHelperStub }
  else
    register(:command_helper, memoize: true) { CommandHelper.new }
    register(:github_helper, memoize: true) { GithubHelper }
  end
end
