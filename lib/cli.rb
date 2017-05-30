require "thor"
require "io/console"

class CLI < Thor

  desc "create-admin USERNAME EMAIL", "Creates an admin user"
  def create_admin(username, email)
    password = ask_new_password
    Admin.create! username: username,
                  email: email,
                  password: password
  end

  desc "disable-admin USERNAME", "Disables an admin user"
  def disable_admin(username)
  end

  private

  def ask_credentials
  end

  def ask_new_password
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
