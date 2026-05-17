module CodeGenerator
  extend ActiveSupport::Concern

  included do
    before_create :generate_unique_code, if: -> { self.has_attribute?(:code) && self.code.blank? }
  end

  def generate_unique_code
    target_name = self.respond_to?(:name) ? self.name : (self.respond_to?(:business_name) ? self.business_name : nil)
    return if target_name.blank?

    base_code = generate_code_from_name(target_name)
    
    existing_codes = self.class.where("code LIKE ?", "#{base_code}%").pluck(:code)
    
    if existing_codes.empty?
      self.code = base_code
    else
      max_suffix = existing_codes.map do |c|
        match = c.match(/-(\d+)$/)
        match ? match[1].to_i : 1
      end.max

      self.code = "#{base_code}-#{max_suffix + 1}"
    end
  end

  private

  def generate_code_from_name(name_str)
    words = name_str.split(' ').select { |word| word.length > 3 }
    if words.size <= 1
      (words.first || name_str)[0, 3].upcase
    else
      base_code = words.map { |word| word[0, 3].upcase }.join('-')
      base_code.split('-').first(2).join('-') 
    end
  end
end
