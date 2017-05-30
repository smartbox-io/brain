require "thor"
require "io/console"

class CLI < Thor

  desc "create-admin USERNAME EMAIL", "Creates an admin user"
  def create_admin(username, email)
    if ask_admin_credentials
      password = ask_new_password
      Admin.create! username: username,
                    email: email,
                    password: password
    end
  end

  desc "disable-admin USERNAME", "Disables an admin user"
  def disable_admin(username)
  end

  private

  def ask_admin_credentials
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

  def ask_new_password
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
