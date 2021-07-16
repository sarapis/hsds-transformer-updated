require_relative "../lib/hsds_transformer"

class Api < Sinatra::Base
  set :bind, '0.0.0.0'

  before do
    content_type 'multipart/form-data'
  end

  # TODO catch the Exceptions and return error reponses
  post "/transform" do
    input_path = params[:input_path]
    mapping_uri = params[:mapping]
    include_custom = params[:include_custom]
    custom_transformer = params[:custom_transformer]

    if mapping_uri.nil?
      halt 422, "A mapping file is required."
    end

    if input_path.nil?
      halt 422, "An input_path is required."
    end

    transformer = HsdsTransformer::Runner.run(
      input_path: input_path,
      mapping: mapping_uri,
      include_custom: include_custom,
      zip_output: true,
      custom_transformer: custom_transformer
    )

    send_file transformer.zipfile_name
  end
end
