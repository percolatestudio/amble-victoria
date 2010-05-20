# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # the new system: we just put down these metas, and jquery/framework.js reads 
  # them and sets up the onload (specify the layout if u require layout fw js)
  def framework_meta_tags(layout_name = '')
    controller = controller_name.gsub('/', '_').camelcase(:lower)
    view = view_name.camelcase(:lower)
    
    "<meta name='fw.controller' content='#{controller}'/>" + 
    "<meta name='fw.view' content='#{view}'/>" +
    (layout_name != '' ? "<meta name='fw.layout' content='#{layout_name}'/>" : '')
  end
  
  def framework_divs(layout_name = '')
    controller = controller_name.gsub('/', '_').camelcase(:lower)
    view = view_name.camelcase(:lower)
    
    framework_div('fw_controller', controller) + framework_div('fw_view', view) +
      (layout_name != '' ? "<div class='framework layout'>#{layout_name}</div>" : '')
  end
  
  def framework_div(name, content)
    "<div id='#{name}' class='framework'>#{content}</div>"
  end
  
  # I'd love to see a better way to grab these
  def controller_name
    @_first_render.base_path || 'no_controller'
  end
  
  def view_name
    @_first_render.name || 'no_view'
  end
  
  # the default classes that get added to the body element when a view renders
  def body_classes(layout_name = '')
    "c_#{controller_name.gsub('/', '_')} v_#{view_name} " + 
       (layout_name != '' ? "l_#{layout_name}" : '')
  end
end
