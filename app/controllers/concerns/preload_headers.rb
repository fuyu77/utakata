# frozen_string_literal: true

module PreloadHeaders
  extend ActiveSupport::Concern
  included do
    after_action :set_preload_headers
  end

  protected

  def set_preload_headers
    return if !request.format.html? ||
              request.xhr? ||
              request.headers['X-XHR-Referer'].present?

    response.headers['Link'] = preload_header_assets.map do |asset|
      "<#{view_context.asset_pack_path(asset[:path])}>; rel=preload; as=#{asset[:as]}"
    end
  end
end
