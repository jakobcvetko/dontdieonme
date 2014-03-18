#!/usr/bin/env ruby

$stdout.sync = true

require 'bundler/setup'
require 'net/http'
require 'logger'
require 'eventmachine'
require 'dotenv'
require 'rollbar/rails'

def rollbar?
	ENV["ROLLBAR_ACCESS_TOKEN"] != nil
end

if rollbar?
	Rollbar.configuration.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
	Rollbar.configuration.endpoint = ENV["ROLLBAR_ENDPOINT"]

	Rollbar.configuration.environment = "production"
	Rollbar.configuration.framework = "Ruby: 2.0.0"
else
	Dotenv.load
end

class Watch
	def initialize url
		@url = url
		@log = Logger.new(STDOUT)
		@log.info "Started tracking: #{url}"
		is_alive?
	end

	def is_alive?
		begin
			uri = URI(@url)
			request = Net::HTTP.get_response(uri)
			unless request.is_a?(Net::HTTPSuccess)
				@log.warn "Error executing request (#{@url})"
				raise "Error executing request"
			else
				@log.info "#{@url} - Is alive."
			end
		rescue Exception => e
			@log.warn "Big error."
			Rollbar.report_exception(e) if rollbar?
		end
	end
end


# Loading URLs
watch_urls = []
$i = 0

until ENV["URL_#{$i}"] == nil
	watch_urls.push ENV["URL_#{$i}"]
	$i += 1;
end

log = Logger.new(STDOUT)
log.warn "Starting app"
log.warn "Loaded #{$i} urls."

watches = watch_urls.map{ |w| Watch.new(w)}
seconds = ENV["DELAY"].to_i

if seconds == 0
	seconds = 100
end

EM.run do
	EM.add_periodic_timer(seconds) do
		watches.each do |w|
			w.is_alive?
		end
	end
end

