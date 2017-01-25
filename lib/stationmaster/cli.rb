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

    desc "-c, [--config]", _("Manage gem configuration") + %( ("#{configuration.computed_path}").)
    map %w[-c --config] => :config
    method_option :edit,
                  aliases: "-e",
                  desc: _("Edit gem configuration."),
                  type: :boolean, default: false
    method_option :info,
                  aliases: "-i",
                  desc: _("Print gem configuration."),
                  type: :boolean, default: false
    def config
      path = self.class.configuration.computed_path

      if options.edit? then `#{editor} #{path}`
      elsif options.info? then say(path)
      else help(:config)
      end
    end

    desc "-v, [--version]", _("Show gem version.")
    map %w[-v --version] => :version
    def version
      say Identity.version_label
    end

    desc "-h, [--help=COMMAND]", _("Show this message or get help for a command.")
    map %w[-h --help] => :help
    def help task = nil
      say and super
    end
  end
end
