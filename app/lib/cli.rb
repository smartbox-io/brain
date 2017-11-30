require "thor"
require "io/console"

class AdminCLI < Thor
  # rubocop:disable Metrics/MethodLength
  desc "create USERNAME EMAIL password", "Creates an admin user"
  def create(username, email, password = nil)
    CLI.ask_admin_credentials unless Admin.count.zero?
    password ||= CLI.ask_new_password
    response, = BrainAdminApi.request(path:    "/admin-api/v1/admins",
                                      method:  :post,
                                      payload: {
                                        admin: {
                                          username: username,
                                          email:    email,
                                          password: password
                                        }
                                      })
    abort "Could not create admin user" unless response.code == 201
  end
  # rubocop:enable Metrics/MethodLength

  desc "disable USERNAME", "Disables an admin user"
  def disable(username)
    # TODO
  end
end

class CellCLI < Thor
  # rubocop:disable Metrics/MethodLength
  desc "ls", "List cells"
  def ls
    table = Terminal::Table.new(headings: ["UUID", "FQDN", "IP Address", "Public IP Address",
                                           "Status", "Block Devices", "Created at"]) do |t|
      Cell.all.each do |cell|
        block_devices = cell.block_devices.map do |block_device|
          ["#{block_device.device}(#{block_device.total_capacity / 1.gigabyte})"]
        end.join ", "
        t << [cell.uuid, cell.fqdn, cell.ip_address, cell.public_ip_address, cell.status,
              block_devices, cell.created_at]
      end
    end
    puts table
  end
  # rubocop:enable Metrics/MethodLength

  desc "accept UUID BLOCK_DEVICE1 BLOCK_DEVICE2...", "Accept cell with uuid UUID, so it can join the
        cluster"
  def accept(uuid, *block_devices)
    cell = Cell.find_by! uuid: uuid
    if cell.accept block_devices: block_devices
      puts "Cell accepted successfully"
    else
      abort "Cell wasn't accepted successfully (was it already accepted?)"
    end
  end

  desc "decomission UUID", "Decomissions cell with uuid UUID"
  def decomission(uuid)
    # TODO
  end

  desc "pause UUID", "Pauses cell with uuid UUID"
  def pause(uuid)
    # TODO
  end
end

class CLI < Thor
  desc "admin SUBCOMMAND", "Manage admin accounts"
  subcommand "admin", AdminCLI

  desc "cell SUBCOMMAND", "Manage cells"
  subcommand "cell", CellCLI

  no_commands do
    # rubocop:disable Naming/PredicateName
    def has_subcommand?(subcommand)
      self.class.subcommands.include? subcommand
    end
    # rubocop:enable Naming/PredicateName
  end

  def self.ask_for(field, noecho: false)
    $stdout.print "#{field}: "
    $stdout.flush
    if noecho
      $stdin.noecho(&:gets).chomp
    else
      $stdin.gets.chomp
    end
  end

  def self.ask_admin_credentials
    puts "Please, enter your administrator credentials:"
    username = ask_for "Username"
    password = ask_for "Password", noecho: true
    puts
    user = Admin.find_by username: username
    return if user.try :authenticate, password
    sleep 5
    abort "Invalid credentials"
  end

  # rubocop:disable Metrics/MethodLength
  def self.ask_new_password
    puts "Please, enter the new password:"
    password = nil
    loop do
      password = ask_for "Password", noecho: true
      password_repeat = ask_for "Repeat Password", noecho: true
      puts
      break if password == password_repeat
      puts "Passwords do not match, please try again"
      puts
      break if Rails.env.test?
    end
    password
  end
  # rubocop:enable Metrics/MethodLength
end
