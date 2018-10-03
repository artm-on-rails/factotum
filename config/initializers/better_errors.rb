if Rails.env.development?
  # this is the IP that rails sees when running in a container on my laptop
  # add more if necessary, look at log lines that look like:
  #
  #   Started GET "/" for 160.68.205.231 at ...
  #
  BetterErrors::Middleware.allow_ip! "160.68.205.231"
  BetterErrors::Middleware.allow_ip! "172.18.0.2"
  BetterErrors.application_root = Rails.root.parent.to_s
end
