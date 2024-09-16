# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm do
    state :planed, initial: true
    state :cloning
    state :checking
    state :failed
    state :finished

    event :start do
      after { RepositoryCloneJob.perform_later(self) }
      transitions from: :planed, to: :cloning
    end

    event :check do
      after { RepositoryCheckJob.perform_later(self) }
      transitions from: :cloning, to: :checking
    end

    event :finish do
      after { CheckMailer.with(check: self).check_error_email.deliver_now unless passed }
      transitions from: :checking, to: :finished
    end

    event :fall do
      after { CheckMailer.with(check: self).check_error_email.deliver_now }
      transitions from: %i[checking cloning], to: :failed
    end
  end
end
