class UrlValidator < ActiveModel::Validator
  def validate(record)
    options[:fields].each do |field|
      unless valid_url?(record.send(field))
        record.errors[field.to_sym] << 'has invalid url format'
      end
    end
  end

  private

  def valid_url?(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end
end
