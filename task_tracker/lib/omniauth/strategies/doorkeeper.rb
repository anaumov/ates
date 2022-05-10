module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      option :name, :doorkeeper

      option :client_options,
             site: 'http://localhost:3000',
             authorize_path: "/oauth/authorize"

      option :provider_ignores_state, true

      uid do
        raw_info["public_id"]
      end

      info do
        {
          email: raw_info["email"],
          name: raw_info["name"],
          role: raw_info["role"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get("accounts/current").parsed
      end
    end
  end
end
