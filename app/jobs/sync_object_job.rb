class SyncObjectJob < ApplicationJob
  queue_as :default

  def perform(sync_token:)
    sync_token.sync_object
  end
end
