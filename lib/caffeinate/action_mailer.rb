# frozen_string_literal: true

require 'mail'

Dir["#{__dir__}/action_mailer/*"].each { |path| require "caffeinate/action_mailer/#{File.basename(path)}" }
