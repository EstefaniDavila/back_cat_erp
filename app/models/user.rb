class User < ApplicationRecord
  include Sanitizable
  has_paper_trail

  belongs_to :roleable, polymorphic: true
  before_create :set_default_data

  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all
  # has_many :password_recoveries, dependent: :delete_all

  has_secure_password
  # api_guard_associations refresh_token: 'refresh_tokens', blacklisted_token: 'blacklisted_tokens'

  # mount_uploader :avatar, AvatarUploader

  enum status: { active: 0, inactive: 1 }
  def set_default_data
    self.status ||= "active"
  end

  def jwt_token_payload
    { user: self.as_json }
  end

  
  private

  # def self.find_for_database_authentication warden_condition
  #   conditions = warden_condition.dup
  #   login = conditions.delete(:login)
  #   conditions = { :status=> "active"}
  #   where(conditions).where(
  #     ["lower(document_number) = :value ", { value: login.strip.downcase}]).first
  # end

 
  def authenticate_answer(answer)
    self.answer_digest == Digest::SHA256.hexdigest(answer.upcase)
  end

  def update_question_and_answer(new_question, new_answer)
    self.update(question: new_question, answer_digest: Digest::SHA256.hexdigest(new_answer.upcase))
  end

  def regenerate_password(password)
    self.password_digest = password
    self.password_confirmation = password
    self.save!
  end

  has_many :refresh_tokens, dependent: :destroy
  has_many :user_tracks, dependent: :destroy
end