class CreateErrorReports < ActiveRecord::Migration[7.0]
  def change
    create_table :error_reports, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      # --- Campos llenados por el usuario al reportar ---
      t.string  :title,          null: false
      t.string  :module_affected, null: false   # ej: "ventas", "alquileres", "inventario"
      t.string  :severity,       null: false    # "critical" | "high" | "medium" | "low"
      t.text    :description,    null: false    # descripción detallada del error
      t.text    :steps_to_reproduce               # pasos para reproducir (opcional)
      t.string  :evidence_url                     # URL de captura/archivo subido (ActiveStorage o externo)

      # --- Estado del reporte ---
      t.string  :status, null: false, default: "pending"
      # "pending" | "accepted" | "rejected"

      # --- Campos llenados por el admin al revisar ---
      t.string  :change_type
      # "emergency" (CHE) | "normal" (CHN) | "standard" (CHS)
      # Solo se llena cuando el admin acepta o rechaza

      t.string  :change_code
      # Código autogenerado al aceptar: CHE-001, CHN-002, CHS-003

      t.text    :admin_notes     # Observaciones del admin (motivo de rechazo, aclaraciones)
      t.datetime :reviewed_at   # Fecha en que el admin tomó la decisión

      # --- Integración Jira ---
      t.string  :jira_issue_key  # ej: "PROY-45"
      t.string  :jira_status     # columna actual en el tablero Jira

      # --- Relaciones ---
      t.uuid    :reported_by_id, null: false   # Usuario que reporta (FK → users)
      t.uuid    :reviewed_by_id               # Admin que revisa (FK → users)

      t.timestamps null: false
    end

    add_index :error_reports, :reported_by_id
    add_index :error_reports, :reviewed_by_id
    add_index :error_reports, :status
    add_index :error_reports, :change_code, unique: true, where: "change_code IS NOT NULL"

    add_foreign_key :error_reports, :users, column: :reported_by_id
    add_foreign_key :error_reports, :users, column: :reviewed_by_id
  end
end