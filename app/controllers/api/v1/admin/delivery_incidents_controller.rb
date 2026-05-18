# app/controllers/api/v1/admin/delivery_incidents_controller.rb
module Api
  module V1
    module Admin
      class DeliveryIncidentsController < ApplicationController
        protect_from_forgery with: :null_session
        before_action :set_incident, only: [:show, :update, :destroy]
        skip_before_action :verify_authenticity_token, raise: false

        # GET /api/v1/admin/delivery_incidents
        def index
          @incidents = DeliveryIncident.includes(:reported_by, :delivery_guide)
                                       .all
                                       .order(created_at: :desc)
          render json: @incidents, status: :ok
        end

        # GET /api/v1/admin/delivery_incidents/:id
        def show
          render json: @incident.as_json(
            include: {
              reported_by: { only: [:id, :email, :full_name] },
              delivery_guide: { only: [:id, :guide_number, :status] }
            }
          ), status: :ok
        end

        # GET /api/v1/admin/delivery_guides/:delivery_guide_id/incidents
        def by_delivery_guide
          @incidents = DeliveryIncident.includes(:reported_by)
                                       .where(delivery_guide_id: params[:delivery_guide_id])
                                       .order(created_at: :desc)
          render json: @incidents, status: :ok
        end

        # GET /api/v1/admin/delivery_incidents/by_type/:incident_type
        def by_type
          if DeliveryIncident.incident_types.keys.include?(params[:incident_type])
            @incidents = DeliveryIncident.includes(:reported_by, :delivery_guide)
                                         .where(incident_type: params[:incident_type])
                                         .order(created_at: :desc)
            render json: @incidents, status: :ok
          else
            render json: { error: 'Invalid incident type' }, status: :unprocessable_entity
          end
        end

        # GET /api/v1/admin/delivery_incidents/types/list
        def incident_types_list
          render json: { incident_types: DeliveryIncident.incident_types.keys }, status: :ok
        end

        # POST /api/v1/admin/delivery_incidents
        def create
          @incident = DeliveryIncident.new(incident_params)
          @incident.reported_by_id = params[:incident][:reported_by_id] || current_user&.id

          if @incident.save
            render json: @incident, status: :created
          else
            render json: { errors: @incident.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/delivery_incidents/:id
        def update
          if @incident.update(incident_params)
            render json: @incident, status: :ok
          else
            render json: { errors: @incident.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/delivery_incidents/:id
        def destroy
          @incident.destroy
          head :no_content
        end

        private

        def set_incident
          @incident = DeliveryIncident.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Incident not found' }, status: :not_found
        end

        def incident_params
          params.require(:delivery_incident).permit(
            :incident_type, :description, :reported_by_id, :delivery_guide_id
          )
        end
      end
    end
  end
end