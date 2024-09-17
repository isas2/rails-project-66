# frozen_string_literal: true

class RepositoryCloneJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = Repository::Check.find_by(id: check_id)
    creds = "#{check.repository.user.nickname}:#{check.repository.user.token}@"
    # fix for Hexlet tests
    # clone_url = check.repository.clone_url.insert(8, creds)
    clone_url = "https://#{creds}github.com/#{check.repository.full_name}.git"

    tmp_dir = "tmp/jobs/#{check.repository.full_name}"
    FileUtils.mkdir_p(tmp_dir)
    commands = [
      { title: I18n.t('jobs.clone.clone'), cmd: "git clone #{clone_url} #{tmp_dir} > /dev/null 1>&1" },
      { title: I18n.t('jobs.clone.id'), cmd: "git -C #{tmp_dir} rev-parse --short HEAD" }
    ]

    commander = ApplicationContainer[:command_helper]
    stdout, stderr, exit_status = commander.execute(commands)

    if exit_status.positive?
      check.output = stderr.gsub(/#{URI::DEFAULT_PARSER.make_regexp}/, '')
      check.fall!
      FileUtils.rm_rf(tmp_dir)
    else
      check.commit_id = stdout
      check.check!
    end
  end
end
