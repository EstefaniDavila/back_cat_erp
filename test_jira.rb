require 'httparty'
require 'json'
require 'base64'
require 'dotenv'
Dotenv.load('.env')

url = "#{ENV['JIRA_URL']}/rest/api/3/issue"
credentials = Base64.strict_encode64("#{ENV['JIRA_EMAIL']}:#{ENV['JIRA_API_TOKEN']}")

payload = {
  fields: {
    project: { key: ENV['JIRA_PROJECT_KEY'] },
    summary: "[TEST] Test Issue",
    issuetype: { name: 'Task' },
    priority: { name: 'Medium' },
    description: {
      type: 'doc',
      version: 1,
      content: [{
        type: 'paragraph',
        content: [{ type: 'text', text: "Test description" }]
      }]
    }
  }
}

puts "URL: #{url}"
puts "Project Key: #{ENV['JIRA_PROJECT_KEY']}"
puts "Payload: #{payload.to_json}"

response = HTTParty.post(
  url,
  headers: {
    'Authorization' => "Basic #{credentials}",
    'Content-Type'  => 'application/json'
  },
  body: payload.to_json
)

puts "Status: #{response.code}"
puts "Response: #{response.body}"
