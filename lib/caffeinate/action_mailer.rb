# frozen_string_literal: true

require "mail"

Dir["#{File.expand_path(File.dirname(__FILE__))}/action_mailer/*"].each { |path| require "caffeinate/action_mailer/#{File.basename(path)}" }
