# Renders an ItemContainer as a <div> element and its containing items as <a> elements.
# It only renders 'selected' elements.
#
# By default, the renderer sets the item's key as dom_id for the rendered <a> element unless the config option <tt>autogenerate_item_ids</tt> is set to false.
# The id can also be explicitely specified by setting the id in the html-options of the 'item' method in the config/navigation.rb
# The ItemContainer's dom_class and dom_id are applied to the surrounding <div> element.
#
class CustomBreadcrumbs < SimpleNavigation::Renderer::Base

  def render(item_container)
    content_tag(:div, a_tags(item_container).join(join_with), {:id => item_container.dom_id, :class => item_container.dom_class})
  end

  protected

  def a_tags(item_container)
    item_container.items.inject([]) do |list, item|
      if item.selected?
        list << tag_for(item) if item.selected?
        if include_sub_navigation?(item)
          list.concat a_tags(item.sub_navigation)
        end
      end
      list
    end
  end

  def join_with
    @join_with ||= options[:join_with] || " "
  end

  def tag_for(item)
    SimpleNavigation::Item.send(:define_method, :last_and_selected?) do 
      selected_by_condition?
    end
    if item.url.nil?
      content_tag('span', item.name, item.html_options.except(:class,:id))
    else
      html_opts = {:method => item.method}.merge(item.html_options.except(:id))
      url = item.url
      unless item.last_and_selected?
        html_opts.delete :class 
      else
        html_opts[:class].sub!(item.selected_class, "")
        url = nil
      end
      if url
        link_to(item.name, url, html_opts)
      else
        content_tag(:span, item.name, html_opts)
      end
    end
  end
end