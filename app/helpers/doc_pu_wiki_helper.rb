module DocPuWikiHelper

  def acronym_info_tag(str)
    return "<acronym title=\"#{str}\">(?)</acronym>".html_safe
  end
  
end
