# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, dependent: :destroy

  validates :github_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :full_name, presence: true
  validates :clone_url, presence: true
  validates :ssh_url, presence: true

  enumerize :language, in: %i[Ruby]
end
