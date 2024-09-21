# frozen_string_literal: true

class CheckReportHelper
  class << self
    def passed?(check)
      check.output && error_count(check).zero?
    end

    def error_count(check)
      return unless check.output

      data = JSON.parse(check.output)
      if check.repository.language == 'ruby'
        data['summary']['offense_count']
      else
        data.inject(0) { |sum, f| sum + f['errorCount'] + f['warningCount'] }
      end
    end

    def report(check)
      return [] unless check.output

      repo_name = check.repository.full_name
      data = JSON.parse(check.output)
      if check.repository.language == 'ruby'
        report_ruby(data, repo_name)
      else
        report_javascript(data, repo_name)
      end
    end

    private

    def report_ruby(data, repo_name)
      result = []
      dir_length = "tmp/jobs/#{repo_name}/".length
      data['files'].each do |file|
        next unless file['offenses'].count.positive?

        offenses = file['offenses'].map do |offense|
          [offense['message'], offense['cop_name'], "#{offense['location']['start_line']}:#{offense['location']['start_column']}"]
        end
        result << { path: file['path'][dir_length..], offenses: }
      end
      result
    end

    def report_javascript(data, repo_name)
      result = []
      data.each do |file|
        next unless file['messages'].count.positive?

        offenses = file['messages'].map do |offense|
          [offense['message'], offense['ruleId'], "#{offense['line']}:#{offense['column']}"]
        end
        result << { path: file['filePath'].split("#{repo_name}/")[1], offenses: }
      end
      result
    end
  end
end
