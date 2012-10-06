module ApplicationHelper
  def top_menu_class(instance)
    'active' if controller.instance_of?(instance)
  end

end
