# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(check)
    tmp_dir = "tmp/jobs/#{check.repository.full_name}"
    commands = [
      { title: I18n.t('jobs.check.check'), cmd: "bundle exec rubocop #{tmp_dir} --format json" }
    ]

    commander = ApplicationContainer[:command_helper]
    stdout, stderr, exit_status = commander.execute(commands)

    if exit_status > 1
      check.output = stderr
      check.fall!
    else
      check.output = stdout
      data = JSON.parse(stdout)
      check.result = data['summary']['offense_count'].zero?
      check.finish!
    end
    FileUtils.rm_rf(tmp_dir)
  end
end
