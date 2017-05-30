require "thor"

class CLI < Thor

  desc "create-admin USERNAME EMAIL", "Creates an admin user"
  def create_admin(username, email)
  end

  desc "disable-admin USERNAME", "Disables an admin user"
  def disable_admin(username)
  end

end
