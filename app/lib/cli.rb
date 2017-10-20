require "thor"
require "io/console"

class AdminCLI < Thor
  desc "create USERNAME EMAIL", "Creates an admin user"
  def create(username, email)
    return unless ask_admin_credentials
    password = CLI.ask_new_password
    Admin.create! username: username,
                  email:    email,
                  password: password
  end

  desc "disable USERNAME", "Disables an admin user"
  def disable(username)
    # TODO
  end
end

class CellCLI < Thor
  # rubocop:disable Metrics/ParameterLists
  desc "ls", "List cells"
  def ls
    table = Terminal::Table.new(headings: ["UUID", "FQDN", "IP Address", "Public IP Address",
                                           "Status", "Created at"]) do |t|
      Cell.pluck(:uuid, :fqdn, :ip_address, :public_ip_address, :status, :created_at)
          .each do |uuid, fqdn, ip_address, public_ip_address, status, created_at|
        t << [uuid, fqdn, ip_address, public_ip_address, status, created_at]
      end
    end
    puts table
  end
  # rubocop:enable Metrics/ParameterLists

  desc "accept UUID", "Accept cell with uuid UUID, so it can join the cluster"
  def accept(uuid)
    cell = Cell.find_by! uuid: uuid
    if cell.accept
      puts "Cell accepted successfully"
    else
      puts "Cell wasn't accepted successfully (was it already accepted?)"
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

  # rubocop:disable Naming/PredicateName
  def has_subcommand?(subcommand)
    self.class.subcommands.include? subcommand
  end
  # rubocop:enable Naming/PredicateName

  def self.ask_for(field, noecho: false)
    STDOUT.print "#{field}: "
    STDOUT.flush
    if noecho
      STDIN.noecho(&:gets).chomp
    else
      STDIN.gets.chomp
    end
  end

  # rubocop:disable Metrics/MethodLength
  def self.ask_admin_credentials
    return true if Admin.count.zero?
    puts "Please, enter your administrator credentials:"
    username = ask_for "Username"
    password = ask_for "Password", noecho: true
    puts
    user = Admin.find_by username: username
    if user.try :authenticate, password
      true
    else
      sleep 5
      puts "Invalid credentials"
      false
    end
  end
  # rubocop:enable Metrics/MethodLength

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
    end
    password
  end
  # rubocop:enable Metrics/MethodLength
end
