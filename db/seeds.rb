# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def notify(message)
  puts "[seeding] #{message}"
  yield
end

if !Rails.env.production?

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
      end
    end
  end

  notify "Creating volumes" do
    Cell.all.each do |cell|
      cell.volumes.find_or_create_by(mountpoint: "/storage1") do |volume|
        volume.total_capacity = 2048
        volume.available_capacity = 2048
      end
    end
  end

end
