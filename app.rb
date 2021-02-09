# frozen_string_literal: true

require './services/urls_service'
require 'bundler'
require './lib/validators'

ENV['RACK_ENV'] ||= 'development'

Bundler.require :default, ENV['RACK_ENV'].to_sym

class App < Sinatra::Application
  urls_service = UrlsService.new
  set :show_exceptions, false

  before do
    content_type 'application/json'
  end

  get '/' do
    'nothing here'
  end

  get '/visited_domains' do
    response_message = {}

    status = Validators.visited_domains(params)
    response_message[:status] = status

    status == :ok && response_message[:domains] = urls_service.uniq_domains(params[:from], params[:to])

    response_message.to_json
  end

  post '/visited_links' do
    response_message = {}

    status = Validators.visited_links(params)
    response_message[:status] = status

    status == :ok && urls_service.add_urls(params[:links])

    response_message.to_json
  end
end
