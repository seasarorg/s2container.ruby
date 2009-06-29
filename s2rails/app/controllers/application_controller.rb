# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  #
  # S2ContainerからActionControllerインスタンスを取得します。
  #
  def self.process(request, response)
    container = S2Rails.get_s2container(request)
    if container.has_component_def(self)
      result = container.get(self).process(request, response)
      container.destroy
      return result
    else
      return super # new.process(request, response);
    end
  end
end
