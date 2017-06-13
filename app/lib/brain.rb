class Brain

  # FIXME: add specific exceptions (unfeasible situations...)
  # FIXME: take sync tokens into account when calculating convergence
  def self.converge_object(object)
    desired_replica_number = [object.backup_size, object.replica_size].max
    current_replica_number = object.backups_and_replicas.count
    return true if current_replica_number >= desired_replica_number
    candidate_volumes = (CellVolume.cell_healthy - object.cell_volumes).shuffle
    return false if candidate_volumes.count < (desired_replica_number - current_replica_number)
    current_healthy_volumes = object.cell_volumes.cell_healthy
    ActiveRecord::Base.transaction do
      (desired_replica_number - current_replica_number).times do
        source_volume = current_healthy_volumes.sample
        target_volume = candidate_volumes.shift
        sync_token = SyncToken.create source_cell: source_volume.cell,
                                      source_cell_volume: source_volume,
                                      target_cell: target_volume.cell,
                                      target_cell_volume: target_volume,
                                      full_object: object,
                                      status: :scheduled

        SyncObjectJob.perform_later sync_token: sync_token
      end
    end
    true
  end

  def self.sync_object(sync_token:)
    sync_token.target_cell.request path: "/cluster-api/v1/objects",
                                   method: :post,
                                   payload: {
                                     sync_token: sync_token.token
                                   }
  end

end
