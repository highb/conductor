# frozen_string_literal: true

module Stationmaster
  # Gem identity information.
  module Identity
    def self.name
      "stationmaster"
    end

    def self.label
      "Stationmaster"
    end

    def self.version
      "0.1.0"
    end

    def self.version_label
      "#{label} #{version}"
    end

    def self.file_name
      ".#{name}rc"
    end
  end
end
