require 'bundler'
Bundler.setup

require 'sinatra'
require 'json'
require 'digest/sha2'
require 'octokit'

$stdout.sync = true
class TravisWebhook < Sinatra::Base
  set :token, ENV['TRAVIS_USER_TOKEN']

  get '/' do
    "Waiting for build"
  end

  post '/' do
    if not valid_request?
      puts "Invalid payload request for repository #{repo_slug}"
    else
      puts "Payload is", params[:payload]
      payload = JSON.parse(params[:payload])
      puts "Received valid payload"
      if payload['status'].nil? or (payload['status'] == 0)
        repo = ENV['ORIGIN_REPO']
        dest_branch = ENV['DEST_BRANCH']

        puts "Merging changes into #{repo}/#{dest_branch}"
        passed_commit = payload['commit']
        client = Octokit::Client::new(:access_token => ENV["GITHUB_TOKEN"])
        client.merge(repo, dest_branch, passed_commit, {
                       :commit_message => "Auto-merging #{passed_commit}\n\nTravis: #{payload['status_message']} at #{payload['finished_at']}\n#{payload['build_url']}"})
      else
        puts "Ohh, it seems build #{payload['status_message']}"
      end
    end
  end

  def valid_request?
    digest = Digest::SHA2.new.update("#{repo_slug}#{settings.token}")
    digest.to_s == authorization
  end

  def authorization
    env['HTTP_AUTHORIZATION']
  end

  def repo_slug
    env['HTTP_TRAVIS_REPO_SLUG']
  end
end

run TravisWebhook
