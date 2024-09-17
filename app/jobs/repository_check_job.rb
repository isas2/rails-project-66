# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(check)
    tmp_dir = "tmp/jobs/#{check.repository.full_name}"
    commands = {
      ruby: [{ title: I18n.t('jobs.check.check'), cmd: "bundle exec rubocop #{tmp_dir} --format json" }],
      javascript: [{ title: I18n.t('jobs.check.check'), cmd: "npx --no-eslintrc eslint #{tmp_dir} --format json" }]
    }

    commander = ApplicationContainer[:command_helper]
    stdout, stderr, exit_status = commander.execute(commands[check.repository.language.to_sym])

    pp '***** Debug start *****'
    pp stdout, stderr, exit_status
    pp '***** Debug end *****'

    if exit_status > 1
      check.output = stderr
      check.fall!
    else
      check.output = stdout
      data = JSON.parse(stdout)
      check.passed = if check.repository.language == 'ruby'
                       (data['summary']['offense_count'] || 0).zero?
                     else
                       (data.inject(0) { |sum, f| sum + f['errorCount'] + f['fatalErrorCount'] + f['warningCount'] } || 0).zero?
                     end
      check.finish!
    end
    FileUtils.rm_rf(tmp_dir)
  end
end
