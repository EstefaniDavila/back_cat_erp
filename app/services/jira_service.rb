class JiraService
  def initialize(error_report)
    @report = error_report
  end

  def create_issue
    response = HTTParty.post(
      "#{ENV['JIRA_URL']}/rest/api/3/issue",
      headers: {
        'Authorization' => "Basic #{credentials}",
        'Content-Type'  => 'application/json'
      },
      body: payload.to_json
    )

    if response.code == 201
      data = JSON.parse(response.body)
      @report.update_columns(
        jira_issue_key: data['key'],
        jira_status: 'Open'
      )
      true
    else
      Rails.logger.error("[Jira] Error #{response.code}: #{response.body}")
      false
    end
  rescue StandardError => e
    Rails.logger.error("[Jira] Exception: #{e.message}")
    false
  end

  private

  def credentials
    Base64.strict_encode64("#{ENV['JIRA_EMAIL']}:#{ENV['JIRA_API_TOKEN']}")
  end

  def payload
    {
      fields: {
        project: { key: ENV['JIRA_PROJECT_KEY'] },
        summary: "[#{@report.change_type || 'ERROR'}] #{@report.title}",
        issuetype: { name: 'Bug' },
        priority: { name: jira_priority },
        description: {
          type: 'doc',
          version: 1,
          content: [{
            type: 'paragraph',
            content: [{ type: 'text', text: build_description }]
          }]
        }
      }
    }
  end

  def build_description
    <<~TEXT
      Módulo afectado: #{@report.module_affected}
      Severidad: #{@report.severity}
      Código de cambio: #{@report.change_code}
      
      Descripción:
      #{@report.description}
      
      Pasos para reproducir:
      #{@report.steps_to_reproduce || 'No especificados'}
    TEXT
  end

  def jira_priority
    priorities = {
      'critical' => 'Highest',
      'high' => 'High',
      'medium' => 'Medium',
      'low' => 'Low'
    }
    priorities[@report.severity] || 'Medium'
  end
end