Rails.configuration.middleware.insert_before('ActionDispatch::ParamsParser', 'NoParse', :urls => ['/autorizacao'])
