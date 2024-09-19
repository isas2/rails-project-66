# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register(:command_helper, memoize: true) { CommandHelperStub.new }
    register(:security_helper, memoize: true) { SecurityHelperStub.new }
    register(:octokit, memoize: true) { OctokitStub }
  else
    register(:command_helper, memoize: true) { CommandHelper.new }
    register(:security_helper, memoize: true) { SecurityHelper.new }
    register(:octokit, memoize: true) { Octokit::Client }
  end
end
