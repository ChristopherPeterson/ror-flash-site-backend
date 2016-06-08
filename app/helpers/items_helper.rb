module ItemsHelper
  def path_to_url(path)
    request.protocol + request.host_with_port + path
  end
end