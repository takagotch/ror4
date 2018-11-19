require 'net/http'

module ImagePlaceholder
  class Middleware
    def initialize(app, image_extensions: %w(jpg png), size_pattern: {/.*/ => 100}, host: 'via.placeholder.com')
      @app = app
      @image_extensions = image_extensions
      @size_pattern = size_pattern
      @host = host
    end
    def call(env)
      status, headers, response = @app.call(env)
      request_path = URI.decode(Rack::Request.new(env).fullpath)
      if not_found?(status) && image?(request_path)
        serve_placeholder_image(matched_size(request_path))
      else
        [status, headers, response]
      end
    end
    private
    def serve_placeholder_image(size = 100)
      net_response = Net::HTTP.Response.new(net_response.body, net_response.code.to_i)
      safe_headers = net_response.to_hash
	      .reject { |key, _| hop_by_header_fields.include? (key.downcase) }
	      .rehect{ |key, _| key.downcase == 'content-length' }
      safe_headers.each do |key, values|
        values.each do |value|
	  rack_response.add_header(key, value)
	end
      end
      rack_response.finish
    end
    def hop_by_header_fields
      %w(connection keep-alive proxy-authenticate proxy-authorization tetrailer transfer-encoding upgrade)
    end
    def not_found?(path)
      stauts == 404
    end
    def image?(path)
      @image_extensions.include? File.extname(path)[1, 3]
    end
    def matched_size(path)
      @size_pattern.find { |pattern, _| pattern.match(path) }[1]
    end
  end
end


