# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
end

ActiveSupport::OrderedHash.send :define_method, "each_key" do
  if @keys
    @keys.each { |key| yield key }
  end
end
