class Brain
  def self.schedule_sync(object:, source_volume:, target_volume:)
    ActiveRecord::Base.transaction do
      sync_token = SyncToken.create source_cell_volume: source_volume,
                                    target_cell_volume: target_volume,
                                    object:             object,
                                    status:             :scheduled
      SyncObjectJob.perform_later sync_token: sync_token
    end
  end

  # FIXME: add specific exceptions (unfeasible situations...)
  # FIXME: take sync tokens into account when calculating convergence
  # rubocop:disable Metrics/MethodLength
  def self.converge_object(object:)
    return true if object.current_replica_number >= object.desired_replica_number
    candidate_volumes = object.candidate_volumes.shuffle
    return false if candidate_volumes.count < (object.desired_replica_number -
                                               object.current_replica_number)
    current_healthy_volumes = object.cell_volumes.cell_healthy
    (object.desired_replica_number - object.current_replica_number).times do
      source_volume = current_healthy_volumes.sample
      target_volume = candidate_volumes.shift
      schedule_sync object: object, source_volume: source_volume, target_volume: target_volume
    end
    true
  end
  # rubocop:enable Metrics/MethodLength

  def self.sync_object(sync_token:)
    sync_token.target_cell.request path:    "/cluster-api/v1/objects",
                                   method:  :post,
                                   payload: {
                                     sync_token: sync_token.token
                                   }
  end
end
