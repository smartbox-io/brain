require "spec_helper"
require "cli"

RSpec.describe CLI do

  let(:admin) { FactoryGirl.create :admin }

  it { is_expected.to have_subcommand "admin" }
  it { is_expected.to have_subcommand "cell" }

  before { with_suppressed_output }

  describe ".ask_for" do
    subject(:cli) { described_class }

    before { allow($stdin).to receive(:gets).and_return "something" }

    context "with echo" do
      it "prints the field name" do
        expect { cli.ask_for("field") }.to output(/field:/).to_stdout
      end

      it "calls to gets" do
        allow($stdin).to receive(:gets).and_return "something"
        cli.ask_for "field"
        expect($stdin).to have_received :gets
      end
    end

    context "without echo" do
      it "prints the field name" do
        expect { cli.ask_for("field", noecho: true) }.to output(/field:/).to_stdout
      end

      it "calls to noecho" do
        allow($stdin).to receive(:noecho).and_return "something"
        cli.ask_for "field", noecho: true
        expect($stdin).to have_received :noecho
      end
    end
  end

  describe ".ask_admin_credentials" do
    subject(:cli) { described_class }

    before do
      allow(described_class).to receive(:sleep)
      allow(described_class).to receive(:ask_for).with("Username").and_return admin.username
      allow(described_class).to receive(:ask_for).with("Password", noecho: true)
                                                 .and_return "password"
    end

    it "asks for the username" do
      cli.ask_admin_credentials

      expect(cli).to have_received(:ask_for).with("Username")
    end

    it "asks for the password" do
      cli.ask_admin_credentials

      expect(cli).to have_received(:ask_for).with("Password", noecho: true)
    end

    context "with non existing user" do
      before do
        allow(described_class).to receive(:ask_for).with("Username").and_return "nonexistentuser"
      end

      it "aborts the execution" do
        expect do
          cli.ask_admin_credentials
        end.to raise_error SystemExit
      end

      # rubocop:disable Lint/HandleExceptions
      it "sleeps for 5 seconds" do
        begin
          cli.ask_admin_credentials
        rescue SystemExit
        end
        expect(cli).to have_received(:sleep).with 5
      end
      # rubocop:enable Lint/HandleExceptions

      # rubocop:disable RSpec/ExampleLength
      # rubocop:disable Lint/HandleExceptions
      it "shows an invalid credentials message" do
        expect do
          begin
            cli.ask_admin_credentials
          rescue SystemExit
          end
        end.to output(/Invalid credentials/).to_stderr
      end
      # rubocop:enable RSpec/ExampleLength
      # rubocop:enable Lint/HandleExceptions
    end

    context "with an invalid password" do
      before do
        allow(described_class).to receive(:ask_for).with("Password", noecho: true)
                                                   .and_return "badpassword"
      end

      it "aborts the execution" do
        expect do
          cli.ask_admin_credentials
        end.to raise_error SystemExit
      end

      # rubocop:disable Lint/HandleExceptions
      it "sleeps for 5 seconds" do
        begin
          cli.ask_admin_credentials
        rescue SystemExit
        end
        expect(cli).to have_received(:sleep).with 5
      end
      # rubocop:enable Lint/HandleExceptions

      # rubocop:disable RSpec/ExampleLength
      # rubocop:disable Lint/HandleExceptions
      it "shows an invalid credentials message" do
        expect do
          begin
            cli.ask_admin_credentials
          rescue SystemExit
          end
        end.to output(/Invalid credentials/).to_stderr
      end
      # rubocop:enable RSpec/ExampleLength
      # rubocop:enable Lint/HandleExceptions
    end

    context "with a valid password" do
      it "aborts the execution" do
        expect do
          cli.ask_admin_credentials
        end.not_to raise_error SystemExit
      end
    end
  end

  describe ".ask_new_password" do
    subject(:cli) { described_class }

    let(:password) { "password" }

    context "when password matches its confirmation" do
      before do
        allow(described_class).to receive(:ask_for).with("Password", noecho: true)
                                                   .and_return password
        allow(described_class).to receive(:ask_for).with("Repeat Password", noecho: true)
                                                   .and_return password
      end

      it "returns the password" do
        expect(cli.ask_new_password).to eq password
      end
    end

    context "when password does not match its confirmation" do
      before do
        allow(described_class).to receive(:ask_for).with("Password", noecho: true)
                                                   .and_return "password"
        allow(described_class).to receive(:ask_for).with("Repeat Password", noecho: true)
                                                   .and_return "otherpassword"
      end

      it "shows a passwords do not match message" do
        expect { cli.ask_new_password }.to output(/Passwords do not match/).to_stdout
      end
    end
  end

end
