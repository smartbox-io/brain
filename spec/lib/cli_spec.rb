require "spec_helper"
require "cli"

RSpec.describe CLI do

  it { is_expected.to have_subcommand "admin" }
  it { is_expected.to have_subcommand "cell" }

end
