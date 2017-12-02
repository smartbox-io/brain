class ClusterApi::V1::SyncTokensController < ClusterTokenlessApplicationController
  # rubocop:disable Metrics/MethodLength
  def show
    token = SyncToken.find_by! token: params[:token]
    ok payload: {
      object:      {
        uuid:      token.object.uuid,
        md5sum:    token.object.md5sum,
        sha1sum:   token.object.sha1sum,
        sha256sum: token.object.sha256sum
      },
      source_cell: {
        uuid:       token.source_cell.uuid,
        ip_address: token.source_cell.public_ip_address,
        volume:     token.source_cell_volume.volume
      },
      target_cell: {
        uuid:       token.target_cell.uuid,
        ip_address: token.target_cell.public_ip_address,
        volume:     token.target_cell_volume.volume
      }
    }
  rescue ActiveRecord::RecordNotFound
    forbidden
  end
  # rubocop:enable Metrics/MethodLength
end
