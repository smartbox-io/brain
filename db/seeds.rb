# This file should contain all the record creation needed to seed the database with its default
# values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with
# db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def notify(message)
  puts "[seeding] #{message}"
  yield
end

unless Rails.env.production?

  notify "Creating test user" do
    User.find_or_create_by(username: "test") do |user|
      user.email = "test@example.com"
      user.password = "test"
    end
  end

  notify "Creating test cells" do
    5.times do |i|
      Cell.find_or_create_by(fqdn: "cell#{i + 1}.example.com") do |cell|
        cell.uuid = SecureRandom.uuid
        cell.status = :healthy
        cell.ip_address = IPAddr.new(rand(2**32), Socket::AF_INET).to_s
        cell.public_ip_address = IPAddr.new(rand(2**32), Socket::AF_INET).to_s
      end
    end
  end

  notify "Creating block devices" do
    Cell.all.each do |cell|
      2.times do |i|
        cell.block_devices.find_or_create_by(device: "sd#{("a".ord + i).chr}") do |block_device|
          block_device.total_capacity = 500.gigabytes
        end
      end
    end
  end

  notify "Creating volumes" do
    Cell.all.each do |cell|
      cell.block_devices.each do |block_device|
        2.times do |i|
          volume_name = "#{block_device.device}#{i + 1}"
          block_device.volumes.find_or_create_by(volume: volume_name) do |volume|
            volume.total_capacity = 250.gigabytes
          end
        end
      end
    end
  end

  notify "Creating objects" do
    5.times do |i|
      FullObject.find_or_create_by(name: "README-#{i + 1}") do |object|
        object.user = User.all.sample
        object.uuid = SecureRandom.uuid
        object.size = 200
        SecureRandom.random_bytes.tap do |contents|
          object.md5sum = Digest::MD5.hexdigest contents
          object.sha1sum = Digest::SHA1.hexdigest contents
          object.sha256sum = Digest::SHA256.hexdigest contents
        end
      end
    end
  end

  notify "Creating object replicas" do
    volumes = CellVolume.all.to_a
    FullObject.all.each do |object|
      2.times do
        volume = volumes.shift
        object.replicas.find_or_create_by(cell_volume: volume) do |replica|
          replica.status = :healthy
        end
      end
    end
  end

end
