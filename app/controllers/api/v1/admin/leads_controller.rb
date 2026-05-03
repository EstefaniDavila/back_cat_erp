class Api::V1::Admin::LeadsController < ApplicationController
  include SearchHelper
  
  # skip_before_action :verify_authenticity_token
  # before_action :authenticate_and_set_user 

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    
    leads = Lead.all

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields(fields, keywords, "cont")
      leads = leads.ransack(search_conditions).result
    end

    total_leads = leads.count

    if params[:sort].present?
      field, order = params[:sort].split("%")
      leads = leads.order("#{field} #{order}")
    else
      leads = leads.order(created_at: :desc)
    end

    page = params[:page] || 1
    page_size = params[:pageSize] || 10
    leads = leads.page(page).per(page_size)

    leads_data = leads.map do |lead|
      {
        id: lead.id,
        **lead.attributes.symbolize_keys,
        assigned_to_name: lead.assigned_to ? "#{lead.assigned_to.first_name} #{lead.assigned_to.last_name}" : "Sin asignar",
        created_at: lead.created_at.strftime("%d/%m/%Y %H:%M"),
        updated_at: lead.updated_at.strftime("%d/%m/%Y %H:%M")
      }
    end

    render json: {
      leads: leads_data,
      current_page: leads.current_page,
      total_pages: leads.total_pages,
      per_pages: leads.limit_value,
      total_leads: total_leads
    }, status: :ok
  end

  def show
    lead = Lead.find_by(id: params[:id]) || Lead.find_by(code: params[:code])
    
    if lead
      render json: {
        lead: {
          id: lead.id,
          **lead.attributes.symbolize_keys,
          assigned_to_name: lead.assigned_to ? "#{lead.assigned_to.first_name} #{lead.assigned_to.last_name}" : "Sin asignar",
          created_at: lead.created_at.strftime("%d/%m/%Y %H:%M"),
        },
        status: :ok
      }
    else
      render json: { error: "Lead no encontrado" }, status: :not_found
    end
  end

  # Función especial para que el Gerente asigne un Lead a un Asesor
  def assign
    lead = Lead.find(params[:id])
    advisor = Advisor.find(params[:advisor_id])

    if lead.update(assigned_to: advisor, status: 'assigned')
      render json: { message: "Lead asignado exitosamente al asesor #{advisor.first_name}", lead: lead }, status: :ok
    else
      render json: { message: "Error al asignar", errors: lead.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    lead = Lead.find(params[:id])

    if lead.update(lead_params)
      render json: { message: "Lead actualizado con éxito", lead: lead }, status: :ok
    else
      render json: { message: "No se pudo actualizar el lead", errors: lead.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email, :phone, :source, :type, :status, :priority, :notes, :client_id, :assigned_to_id)
  end
end
