# frozen_string_literal: true

require 'sinatra'
require 'net/http'
require 'json'
require_relative './github_to_cctray.rb'

get '/' do
  # redirect to example project
  redirect '/build-canaries/nevergreen/nevergreen.yml'
end

get '/:group/:repo/:workflow' do |group, repo, workflow|
  content_type 'application/xml'

  uri = URI("https://api.github.com/repos/#{group}/#{repo}/actions/workflows/#{workflow}/runs")
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = request.env['HTTP_AUTHORIZATION']
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
  payload = JSON.parse(res.body)

  GithubToCCTray.new.convert_to_xml(payload, params[:branch])
end
