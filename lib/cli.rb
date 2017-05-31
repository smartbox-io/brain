require "thor"
require "io/console"

class AdminCLI < Thor
  desc "create USERNAME EMAIL", "Creates an admin user"
  def create(username, email)
    if ask_admin_credentials
      password = CLI.ask_new_password
      Admin.create! username: username,
                    email: email,
                    password: password
    end
  end

  desc "disable USERNAME", "Disables an admin user"
  def disable(username)
  end
end

class CellCLI < Thor
  desc "ls", "List cells"
  def ls
    table = Terminal::Table.new(headings: ["UUID", "FQDN", "IP Address", "Status", "Created at"]) do |t|
      Cell.all.each do |cell|
        t << [cell.uuid, cell.fqdn, cell.ip_address, cell.status, cell.created_at]
      end
    end
    puts table
  end

  desc "accept UUID", "Accept cell with uuid UUID, so it can join the cluster"
  def accept(uuid)
    cell = Cell.find_by! uuid: params[:uuid]
    cell.accept
  end
end

class CLI < Thor
  desc "admin SUBCOMMAND", "Manage admin accounts"
  subcommand "admin", AdminCLI

  desc "cell SUBCOMMAND", "Manage cells"
  subcommand "cell", CellCLI

  def self.ask_admin_credentials
    return true if Admin.count == 0
    puts "Please, enter your administrator credentials:"
    STDOUT.print "Username: "
    STDOUT.flush
    username = STDIN.gets.chomp
    STDOUT.print "Password: "
    STDOUT.flush
    password = STDIN.noecho(&:gets).chomp
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

  def self.ask_new_password
    puts "Please, enter the new password:"
    password = nil
    loop do
      STDOUT.print "Password: "
      STDOUT.flush
      password = STDIN.noecho(&:gets).chomp
      puts
      STDOUT.print "Repeat password: "
      STDOUT.flush
      password_repeat = STDIN.noecho(&:gets).chomp
      puts
      if password == password_repeat
        break
      else
        puts "Passwords do not match, please try again"
        puts
      end
    end
    password
  end

end
