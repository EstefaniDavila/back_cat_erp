module Api
  module V1
    module Admin
      class ErrorReportsController < ApplicationController
        before_action :set_error_report, only: [:show, :update, :accept, :reject]

        def index
          reports = ErrorReport.includes(:reported_by, :reviewed_by).recent
          reports = reports.where(status: params[:status]) if params[:status].present?
          reports = reports.where(severity: params[:severity]) if params[:severity].present?
          reports = reports.where(module_affected: params[:module]) if params[:module].present?
          
          render json: reports.map { |r| report_json(r) }
        end

        def my_reports
          reported_by_id = params[:reported_by_id]
          return render json: { error: "reported_by_id es requerido" }, status: :bad_request if reported_by_id.blank?
          
          reports = ErrorReport.where(reported_by_id: reported_by_id).recent
          render json: reports.map { |r| report_json(r) }
        end

        def show
          render json: report_json(@error_report)
        end

        def create
          report = ErrorReport.new(create_params)
          
          if report.save
            render json: report_json(report), status: :created
          else
            render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @error_report.update(update_params)
            render json: report_json(@error_report)
          else
            render json: { errors: @error_report.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def accept
          reviewed_by_id = params[:reviewed_by_id]
          change_type = params[:change_type]
          
          if reviewed_by_id.blank?
            return render json: { error: "reviewed_by_id es requerido" }, status: :bad_request
          end
          
          if change_type.blank?
            return render json: { error: "change_type es requerido" }, status: :bad_request
          end
          
          @error_report.accept!(
            reviewed_by_id: reviewed_by_id,
            change_type: change_type,
            admin_notes: params[:admin_notes]
          )
          render json: report_json(@error_report)
        rescue ArgumentError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end

        def reject
          reviewed_by_id = params[:reviewed_by_id]
          
          if reviewed_by_id.blank?
            return render json: { error: "reviewed_by_id es requerido" }, status: :bad_request
          end
          
          @error_report.reject!(
            reviewed_by_id: reviewed_by_id,
            admin_notes: params[:admin_notes]
          )
          render json: report_json(@error_report)
        end

        private

        def set_error_report
          @error_report = ErrorReport.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Reporte no encontrado" }, status: :not_found
        end

        def create_params
          params.require(:error_report).permit(
            :title, 
            :module_affected, 
            :severity, 
            :description, 
            :steps_to_reproduce, 
            :evidence_url, 
            :jira_issue_key,
            :reported_by_id,
            :reviewed_by_id
          )
        end

        def update_params
          params.require(:error_report).permit(
            :title, 
            :description, 
            :steps_to_reproduce, 
            :evidence_url
          )
        end

        def report_json(r)
          {
            id: r.id,
            title: r.title,
            module_affected: r.module_affected,
            severity: r.severity,
            description: r.description,
            steps_to_reproduce: r.steps_to_reproduce,
            evidence_url: r.evidence_url,
            status: r.status,
            change_type: r.change_type,
            change_code: r.change_code,
            admin_notes: r.admin_notes,
            reviewed_at: r.reviewed_at,
            jira_issue_key: r.jira_issue_key,
            jira_status: r.jira_status,
            reported_by_id: r.reported_by_id,
            reviewed_by_id: r.reviewed_by_id,
            created_at: r.created_at,
            updated_at: r.updated_at
          }
        end
      end
    end
  end
end