require 'net/http'
require 'uri'
require 'json'

# extract key manually since dotenv might not be in load path without bundler
env_content = File.read('.env')
key = env_content.match(/CLAUDE_API_KEY=\"?(.*?)\"?$/)[1]

uri = URI('https://api.anthropic.com/v1/messages')
req = Net::HTTP::Post.new(uri)
req['Content-Type'] = 'application/json'
req['x-api-key'] = key
req['anthropic-version'] = '2023-06-01'
req.body = { model: 'claude-sonnet-5', max_tokens: 300, messages: [] }.to_json
res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {|http| http.request(req) }
puts "CODE: #{res.code}"
puts "BODY: #{res.body}"
