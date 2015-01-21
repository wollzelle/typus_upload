require 'active_support/concern'

module Admin::Uploads
  extend ActiveSupport::Concern

  def preflight
    filename = params[:filename]
    key = upload_prefix + filename
    ext = File.extname(filename)[1..-1]
    content_type = Mime::Type.lookup_by_extension(ext).to_s

    form_data = {
      key: key,
      AWSAccessKeyId: ENV['AWS_ACCESS_KEY_ID'],
      acl: 'public-read',
      'x-amz-meta-filename' => filename,
      'Content-Type' => content_type,
      policy: policy(key, filename, content_type),
      signature: signature(key, filename, content_type)
    }

    render json: { form_data: form_data }.to_json
  end

  private

  def policy_data(key, filename, content_type)
    @policy_data ||= {
      expiration: 10.hours.from_now.utc.iso8601,
      conditions: [
        ["content-length-range", 0, 500.megabytes],
        { bucket: ENV['AWS_BUCKET'] },
        { "x-amz-meta-filename" => filename},
        { 'Content-Type' => content_type },
        { acl: 'public-read' },
        { key: key }
      ]
    }
  end

  def policy(key, filename, content_type)
    @policy ||= Base64.encode64(policy_data(key, filename, content_type).to_json).gsub("\n", "")
  end

  def signature(key, filename, content_type)
    @signature ||= Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest.new('sha1'),
            ENV['AWS_SECRET_ACCESS_KEY'], policy(key, filename, content_type)
          )
        ).gsub("\n", "")
  end

  def upload_prefix
    "#{controller_name}/"
  end
end