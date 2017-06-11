class SyncObjectJob < ApplicationJob
  queue_as :default

  def perform(sync_token:)
    Brain.sync_object sync_token: sync_token
  end
end
