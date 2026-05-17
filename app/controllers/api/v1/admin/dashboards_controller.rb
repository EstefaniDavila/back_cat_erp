class Api::V1::Admin::DashboardsController < ApplicationController
  def index
    total_sales = Quotation.where(status: 'approved').sum(:total) || 0
    total_quotations = Quotation.count
    total_leads = Lead.count
    total_clients = Client.count

    # Recent activity for DataTable
    recent_quotations = Quotation.includes(:client, :advisor).order(created_at: :desc).limit(10).map do |q|
      {
        id: q.code || q.id[0..7],
        client: q.client&.business_name || 'Sin cliente',
        advisor: q.advisor ? "#{q.advisor.first_name} #{q.advisor.last_name}" : 'Sin asesor',
        amount: q.total || q.subtotal || 0,
        status: q.status,
        date: q.created_at.strftime('%Y-%m-%d')
      }
    end

    # Chart data (last 30 days or months)
    # Let's do last 6 months for chart
    months = (0..5).map { |i| i.months.ago.beginning_of_month }
    chart_data = months.reverse.map do |month|
      end_month = month.end_of_month
      {
        month: month.strftime("%b %Y"),
        desktop: Quotation.where(created_at: month..end_month, status: 'approved').sum(:total).to_f,
        mobile: Quotation.where(created_at: month..end_month).where.not(status: 'approved').sum(:total).to_f
      }
    end

    render json: {
      stats: {
        total_sales: total_sales.to_f,
        total_quotations: total_quotations,
        total_leads: total_leads,
        total_clients: total_clients
      },
      recent_activity: recent_quotations,
      chart_data: chart_data
    }, status: :ok
  end
end
