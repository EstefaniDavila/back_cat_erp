module Api
  module V1
    module Admin
      class UsersController < ApplicationController
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token, raise: false
        before_action :set_user, only: [:show, :update, :destroy, :toggle_status, :reset_password]

        include SearchHelper

        # GET /api/v1/admin/users
        def index
          keywords = params[:search_params] || ""
          fields = params[:search_fields]&.split(",") || []
          
          @users = User.includes(:roleable).all

          if fields.present? && keywords.present?
            search_conditions = combine_search_fields2(fields, keywords, "text")
            @users = @users.ransack(search_conditions).result
          end

          if params[:roleable_type].present?
            @users = @users.where(roleable_type: params[:roleable_type])
          end

          if params[:status].present?
            @users = @users.where(status: params[:status])
          end

          total_users = @users.count

          if params[:sort].present?
            field, order = params[:sort].split("%")
            @users = @users.order("#{field} #{order}")
          else
            @users = @users.order(created_at: :desc)
          end

          page = params[:page] || 1
          page_size = params[:pageSize] || 10
          @users = @users.page(page).per(page_size)

          users_data = @users.map do |user|
            {
              **user.as_json(include: { roleable: {} }, methods: [:full_name]),
              created_at: user.created_at.strftime("%d/%m/%Y %H:%M"),
              updated_at: user.updated_at.strftime("%d/%m/%Y %H:%M")
            }
          end

          render json: {
            users: users_data,
            current_page: @users.current_page,
            total_pages: @users.total_pages,
            per_pages: @users.limit_value,
            total_users: total_users
          }, status: :ok
        end

        # GET /api/v1/admin/users/:id
        def show
          render json: @user.as_json(
            include: { roleable: {} },
            methods: [:full_name]
          ), status: :ok
        end

        # POST /api/v1/admin/users
        def create
          # Cuando se crea un rol (ej. Admin, Advisor), su callback `after_create :generate_user` 
          # creará automáticamente el registro de User.
          
          roleable_type = params[:roleable_type]
          
          # Lista de roles permitidos para ser creados desde este panel
          allowed_roles = ['Admin', 'Advisor', 'Manager', 'Technician', 'LogisticsUser', 'Warehouseman']
          
          unless allowed_roles.include?(roleable_type)
            return render json: { error: 'Tipo de rol no permitido o inválido' }, status: :unprocessable_entity
          end

          role_class = roleable_type.constantize
          @role = role_class.new(role_params)

          # Asegurar que se asignen campos obligatorios que no vienen del frontend
          if @role.respond_to?(:status=) && @role.status.blank?
            @role.status = 'active'
          end

          if @role.respond_to?(:code=) && @role.code.blank?
            # Generar un código único simple
            @role.code = "#{roleable_type[0..2].upcase}-#{SecureRandom.hex(4).upcase}"
          end

          if @role.save
            # Al guardar el rol, se generó el user. Lo retornamos.
            render json: @role.user.as_json(
              include: { roleable: {} },
              methods: [:full_name]
            ), status: :created
          else
            render json: { errors: @role.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT/PATCH /api/v1/admin/users/:id
        def update
          ActiveRecord::Base.transaction do
            if user_params.present?
              @user.update!(user_params)
            end

            if role_params.present?
              @user.roleable.update!(role_params)
            end
            
            render json: @user.as_json(
              include: { roleable: {} },
              methods: [:full_name]
            ), status: :ok
          rescue ActiveRecord::RecordInvalid => e
            render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/users/:id
        def destroy
          # Eliminar el registro del rol también eliminará el registro de User
          # debido a `dependent: :destroy` en la relación `has_one :user`.
          begin
            @user.roleable.destroy
            head :no_content
          rescue ActiveRecord::InvalidForeignKey
            render json: { error: 'No se puede eliminar el usuario porque tiene registros asociados. Te recomendamos desactivarlo en su lugar.' }, status: :unprocessable_entity
          end
        end

        # PATCH /api/v1/admin/users/:id/toggle_status
        def toggle_status
          new_status = @user.active? ? 'inactive' : 'active'
          if @user.update(status: new_status)
            render json: { message: "Estado del usuario actualizado a #{new_status}", user: @user.as_json(methods: [:full_name]) }, status: :ok
          else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PATCH /api/v1/admin/users/:id/reset_password
        def reset_password
          document_number = @user.document_number
          if @user.update(password: document_number, password_confirmation: document_number)
            render json: { message: 'Contraseña restablecida exitosamente al número de documento' }, status: :ok
          else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def set_user
          @user = User.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Usuario no encontrado' }, status: :not_found
        end

        def user_params
          # Permitimos actualizar correo (si se maneja desde el User), teléfono, avatar, etc.
          params.require(:user).permit(:email, :phone, :avatar, :status) if params[:user].present?
        end

        def role_params
          # Permite atributos comunes de los roles. 
          if params[:role_attributes].present?
            params.require(:role_attributes).permit(
              :first_name, :last_name, :full_name, :email, 
              :document_number, :document_type, :code, :phone, 
              :commission_rate, :status, :position, :specialty, 
              :certification, :area
            )
          else
            {}
          end
        end
      end
    end
  end
end
