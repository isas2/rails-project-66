# frozen_string_literal: true

class CommandHelperStub
  CMD_STUBS = {
    check01: '{"summary":{"offense_count":0}}',
    check02: '[{"errorCount":0,"warningCount":0}]',
    clone01: '',
    clone02: '111111'
  }.freeze

  def execute(commands)
    [CMD_STUBS[commands.last[:id]], '', 0]
  end
end
