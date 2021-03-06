module Heartwood
  module Icons
    class Form

      attr_accessor :options

      def initialize(options = {})
        @options = options.deep_symbolize_keys.reverse_merge(default_options)
        validate_options!
        init_options!
      end

      def fields
        {
          key: key,
          acl: acl,
          policy: policy_data_json,
          signature: encoded_signature,
          'Content-Type' => nil,
          'AWSAccessKeyId' => aws_access_key_id
        }
      end

      def form_options
        {
          id: form_id,
          method: form_method,
          authenticity_token: false,
          multipart: allow_multiple_files,
          data: {
            template_id: template_id,
            template_container: template_container_id,
            trigger: trigger_id,
            icons: true
          }
        }
      end

      def method_missing(method_name, *args, &block)
        super unless options.keys.include?(method_name.to_sym)
        options[method_name.to_sym]
      end

      def respond_to?(method_name, include_all = false)
        super || options.keys.include?(method_name.to_sym)
      end

      private

      def validate_options!
        return true if aws_access_key_id && aws_secret_access_key && bucket
        raise ArgumentError.new('Missing required AWS configuration.')
      end

      def init_options!
        @options.merge!(url: "https://#{bucket}.s3.amazonaws.com/")
      end

      def default_options
        {
          acl: 'private',
          allow_multiple_files: false,
          aws_access_key_id: Heartwood::Icons.configuration.aws_access_key_id,
          aws_secret_access_key: Heartwood::Icons.configuration.aws_secret_access_key,
          bucket: Heartwood::Icons.configuration.aws_bucket,
          expiration: 10.hours.from_now,
          form_id: 'heartwood-icons',
          form_method: 'post',
          key: '${filename}',
          max_file_size: 50.megabytes,
          template_container_id: "hwupl-#{SecureRandom.hex(6)}",
          template_id: "hwtmpl-#{SecureRandom.hex(6)}",
          trigger_id: nil,
          upload_field_id: 'heartwood-icons-file',
          url_field_class: 'heartwood-icons-url',
          url_field_name: nil,
        }
      end

      def policy_data_json
        Base64.encode64({
          expiration: expiration,
          conditions: [
            ['starts-with', '$utf8', ''],
            ['starts-with', '$key', ''],
            ['starts-with', '$Content-Type', ''],
            ['content-length-range', 0, max_file_size],
            { bucket: bucket },
            { acl: acl }
          ]
        }.to_json).delete("\n")
      end

      def encoded_signature
        Base64.encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest.new('sha1'),
            aws_secret_access_key,
            policy_data_json)
        ).delete("\n")
      end

    end
  end
end
