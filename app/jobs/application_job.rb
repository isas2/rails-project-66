# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # def execute(commands)
  #   result = []
  #   commands.each do |command|
  #     result = run_command(command[:title], command[:cmd])
  #     break if result.last != 0
  #   end
  #   result
  # end
  #
  # def run_command(title, cmd)
  #   Open3.popen3(cmd) do |_stdin, stdout, stderr, wait_thr|
  #     [stdout.read.chomp, "#{title}: #{stderr.read.chomp}", wait_thr.value.exitstatus]
  #   end
  # end
end
