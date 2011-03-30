module SentencedFields
  module ClassMethods
    def sentenced_fields field, separator = ", "
      class_eval <<-EOS
        def sentenced_#{field}
          self.#{field}.join("#{separator}")
        end
        
        def sentenced_#{field}= a_new_value
          self.#{field} = a_new_value.split("#{separator}").collect { |x| x.strip }
        end
      EOS
    end
  end
  
  def self.included klass
    klass.extend ClassMethods
  end
end