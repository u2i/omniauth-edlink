require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Edlink < OmniAuth::Strategies::OAuth2
      class AccessToken < ::OAuth2::AccessToken
        class << self
          def from_hash(client, hash)
            token = hash['$data']['access_token']
            new(client, token, hash['$data'])
          end
        end
      end

      option :name, :edlink
      option :client_options, {
        site: 'https://ed.link',
        authorize_url: '/sso/login',
        token_url: '/api/authentication/token',
        auth_scheme: :request_body,
        access_token_class: AccessToken
      }
      option :uid_field, 'id'

      uid do
        raw_info[options.uid_field.to_s]
      end

      def authorize_params
        super.tap do |params|
          params[:scope] = [:email, :profile]
          params[:response_type] = :code
        end
      end

      info do
        raw_info.slice('email', 'first_name', 'last_name', 'roles', 'district_id', 'school_ids').symbolize_keys
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('https://ed.link/api/v2/my/profile').parsed['$data']
      end

      private

      def callback_url
        full_host + callback_path
      end
    end
  end
end
