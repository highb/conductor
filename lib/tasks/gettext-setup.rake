# frozen_string_literal: true

begin
  gettext_spec = Gem::Specification.find_by_name 'gettext-setup'
  load "#{gettext_spec.gem_dir}/lib/tasks/gettext.rake"
  GettextSetup.initialize(File.absolute_path("../../locales", File.dirname(__FILE__)))
rescue LoadError => error
  puts error.message
end
