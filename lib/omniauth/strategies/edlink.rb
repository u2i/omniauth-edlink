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
      # `state` injected during the request phase is lost by Edlink, you don't get it in the callback phase.
      option :provider_ignores_state, true

      uid do
        raw_info[options.uid_field.to_s]
      end

      def request_phase
        integration_id = request.params['integration_id']
        authorize_path = integration_id.present? ? integration_authorize_path(integration_id) : options.client_options.authorize_url
        redirect client.connection.build_url(URI.join(options.client_options.site, authorize_path), authorize_params)
      end

      def authorize_params
        super
          .merge({ :redirect_uri => callback_url })
          .merge(client.auth_code.authorize_params)
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

      def integration_authorize_path(integration_id)
        "/api/authentication/integrations/#{integration_id}/launch"
      end
    end
  end
end
