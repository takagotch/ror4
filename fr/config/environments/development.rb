Rails.application.configure do
  config.middleware.use ImagePlaceholder::Middleware, host: 'fillmurray.com'
end

Rails.application.configure do
  config.middleware.use ImagePlaceholder::Middleware.size_pattern: {
    %r{/uploads/.*/s_[0-9]+\[a-z]{3}} => 200,
    %r{/uploads/.*/x|-[0-9]+\.[a-z]{3}$} => 750,
    %r{.*} => 1024,
  }
end

Rails.application.configure do
  config.middleware.use ImagePlaceholder::Middleware, image_extensions: %w(jpg jpeg png webp gif)
end



