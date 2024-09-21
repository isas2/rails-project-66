# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = Repository::Check.find_by(id: check_id)
    tmp_dir = "tmp/jobs/#{check.repository.full_name}"
    commands = {
      ruby: [
        { title: I18n.t('jobs.check.check'),
          cmd: "bundle exec rubocop --config ./.rubocop.yml #{tmp_dir} --format json",
          stub: '{"summary":{"offense_count":0}}' }
      ],
      javascript: [
        { title: I18n.t('jobs.check.check'),
          cmd: "npx --no-eslintrc eslint #{tmp_dir} -c eslint.config.js --format json",
          stub: '[{"errorCount":0,"warningCount":0}]' }
      ]
    }

    commander = ApplicationContainer[:command_helper]
    begin
      stdout, stderr, exit_status = commander.execute(commands[check.repository.language.to_sym])

      if exit_status > 1
        check.output = stderr
        check.fall!
      else
        check.output = stdout
        check.passed = CheckReportHelper.passed?(check)
        check.finish!
      end
      FileUtils.rm_rf(tmp_dir)
    rescue StandardError => e
      check.output = e
      FileUtils.rm_rf(tmp_dir)
      check.fall!
    end
  end
end
