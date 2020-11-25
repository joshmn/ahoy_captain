# frozen_string_literal: true

Rails.application.routes.draw do
  mount Caffeinate::Engine => '/caffeinate'
end
