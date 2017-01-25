# frozen_string_literal: true

require "thor"
require "thor/actions"
require "thor_plus/actions"
require "runcom"
require "gettext-setup"

module Stationmaster
  GettextSetup.initialize(File.absolute_path("../../locales", File.dirname(__FILE__)))
  FastGettext.locale = GettextSetup.negotiate_locale(Locale.candidates(type: :cldr).reverse.join(','))

  # The Command Line Interface (CLI) for the gem.
  class CLI < Thor
    include Thor::Actions
    include ThorPlus::Actions

    package_name Identity.version_label

    def self.configuration
      Runcom::Configuration.new file_name: Identity.file_name
    end

    def initialize args = [], options = {}, config = {}
      super args, options, config
    end

    class_option :verbose,
      aliases: "-v",
      desc: _("Display verbose logging information."),
      type: :boolean

    class_option :file,
      aliases: "-f",
      desc: _("Specify which config file contains the boarding information."),
      type: :string, default: "boarding.conf"

    desc "s, [setup]", _("Create new config file for storing boarding information.")
    map %w[s setup] => :setup
    def setup
      if File.exist?(options[:file])
        say _("Boarding informatoin file %{file} already exists.") % { file: options[:file] }
      else
        say _("Creating boarding config file %{file}...") % { file: options[:file] }
        File.open(options[:file], "w+") do |f|
          f.write("{}")
        end
      end
    end

    desc "n, [new] NAME", _("Create a new boarding ticket")
    map %w[n new] => :new_ticket
    method_option :enable,
                  aliases: "-e",
                  desc: _("Enable the boarding ticket."),
                  type: :boolean, default: true
    method_option :expiration,
                  aliases: "-x",
                  desc: _("When the boarding ticket expires."),
                  type: :string, default: nil
    method_option :description,
                  aliases: "-d",
                  desc: _("Description of what the boarding ticket is for."),
                  type: :string, default: nil
    method_option :ticket,
                  aliases: "-t",
                  desc: _("Tracking ticket for the boarding ticket."),
                  type: :string, default: nil
    method_option :target_version,
                  aliases: "-v",
                  desc: _("The target version for the boarding ticket."),
                  type: :string, default: nil
    def new_ticket(name)
      config = fetch_config(options[:file])
      puts config

      say _("Creating new boarding ticket for %{name}...") % { name: name }

      if options[:enable]
        say _("Enabling %{name}...") % { name: name }
      else
        say _("Disabling %{name}...") % { name: name }
      end

      if options[:expiration]
        say _("Setting expiration to %{expiration_time} on %{name}...") % { expiration_time: options[:expriation], name: name }
      else
        say _("Setting expiration to %{expiration_time} on %{name}...") % { expiration_time: "30 days from now", name: name }
      end

      if options[:description]
        say _("Setting description to %{description} on %{name}...") % { description: options[:description], name: name }
      end

      if options[:ticket]
        say _("Setting tracking ticket number to %{ticket} on %{name}...") % { ticket: options[:ticket], name: name }
      end

      if options[:target_version]
        say _("Setting target version to %{version} on %{name}...") % { version: options[:target_version], name: name }
      end
    end

    desc "u, [update] NAME", _("Update a boarding ticket")
    map %w[u update] => :update_ticket
    method_option :enable,
                  aliases: "-e",
                  desc: _("Enable the boarding ticket."),
                  type: :boolean, default: nil
    method_option :expiration,
                  aliases: "-x",
                  desc: _("When the boarding ticket expires."),
                  type: :string, default: nil
    method_option :description,
                  aliases: "-d",
                  desc: _("Description of what the boarding ticket is for."),
                  type: :string, default: nil
    method_option :ticket,
                  aliases: "-t",
                  desc: _("Tracking ticket for the boarding ticket."),
                  type: :string, default: nil
    method_option :target_version,
                  aliases: "-v",
                  desc: _("The target version for the boarding ticket."),
                  type: :string, default: nil
    def update_ticket(name)
      config = fetch_config(options[:file])
      puts config

      say _("Updating boarding ticket %{name}...") % { name: name}

      if options[:enable]
        say _("Enabling %{name}...") % { name: name }
      else
        say _("Disabling %{name}...") % { name: name }
      end

      if options[:expiration]
        say _("Setting expiration to %{expiration_time} on %{name}...") % { expiration_time: options[:expriation], name: name }
      else
        say _("Setting expiration to %{expiration_time} on %{name}...") % { expiration_time: "30 days from now", name: name }
      end

      if options[:description]
        say _("Setting description to %{description} on %{name}...") % { description: options[:description], name: name }
      end

      if options[:ticket]
        say _("Setting tracking ticket number to %{ticket} on %{name}...") % { ticket: options[:ticket], name: name }
      end

      if options[:target_version]
        say _("Setting target version to %{version} on %{name}...") % { version: options[:target_version], name: name }
      end
    end

    desc "s, [show] NAME", _("Show usage of a boarding ticket") % { name: name}
    map %w[s show] => :show_ticket
    def show_ticket(name)
      config = fetch_config(options[:file])
      puts config

      say _("Grepping around for the ticket %{name}...")
      say _("When %{name} expires...")
    end

    desc "b, [board] NAME", _("Board a feature")
    map %w[b board] => :board_feature
    def board_feature(name)
      config = fetch_config(options[:file])
      puts config

      say _("Boarding feature %{name}...")
      say _("I hope you've removed all references to the %{name}...") % { name: name}
      say _("Setting %{name} as boarded so it will throw exceptions if called...") % { name: name}
    end

    desc "c, [config]", _("Manage Stationmaster configuration") + %( ("#{configuration.computed_path}").)
    map %w[c config] => :config
    method_option :edit,
                  aliases: "-e",
                  desc: _("Edit Stationmaster configuration."),
                  type: :boolean, default: false
    method_option :info,
                  aliases: "-i",
                  desc: _("Print Stationmaster configuration."),
                  type: :boolean, default: false
    def config
      path = self.class.configuration.computed_path

      if options.edit? then `#{editor} #{path}`
      elsif options.info? then say(path)
      else help(:config)
      end
    end

    desc "-v, [--version]", _("Show Stationmaster version.")
    map %w[-v --version] => :version
    def version
      say Identity.version_label
    end

    desc "-h, [--help=COMMAND], [help COMMAND]", _("Show this message or get help for a command.")
    map %w[-h --help help] => :help
    def help task = nil
      say and super
    end

    no_commands do
      def fetch_config(file)
        if File.exist?(file)
          say _("Fetching config from %{file}...") % { file: file }
          return Stationmaster::BoardingInfo.new(options[:file])
        else
          say _("Boarding config file %{file} does not exist.") % { file: file }
          exit 1
        end
      end
    end
  end
end
