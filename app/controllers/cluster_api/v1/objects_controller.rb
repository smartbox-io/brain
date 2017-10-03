class ClusterApi::V1::ObjectsController < ClusterApplicationController
  def create
    ActiveRecord::Base.transaction do
      upload_token = current_user.upload_tokens.find_by! token:       params[:upload_token],
                                                         cell_volume: @cell.volumes,
                                                         remote_ip:   params[:client_ip]
      update_replica_status object: object, upload_token: upload_token
      upload_token.destroy
    end
    ConvergeObjectJob.perform_later object: object
    ok
  end

  private

  def object
    @object ||= current_user.objects.find_or_create_by(uuid: object_params[:uuid]) do |object|
      object_attributes.each do |attr|
        object.send :"#{attr}=", object_params[attr]
      end
    end
  end

  def update_replica_status(object:, upload_token:)
    object.replicas.find_or_create_by(cell_volume: upload_token.cell_volume) do |replica|
      replica.status = :healthy
    end
  end

  def object_attributes
    %i[uuid name size md5sum sha1sum sha256sum]
  end

  def object_params
    params.require(:object).permit object_attributes
  end
end
