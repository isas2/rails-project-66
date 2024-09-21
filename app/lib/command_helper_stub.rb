# frozen_string_literal: true

class CommandHelperStub
  def execute(commands)
    [commands.last[:stub], '', 0]
  end
end
