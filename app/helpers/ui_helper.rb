module UiHelper
  # a replaced header etc
  def replaced_tag(tag, text, img, html_opts = {})
    content_tag(tag, {:class => "replaced"}.merge(html_opts)) do
      image_tag(img, :alt => text) + text
    end
  end
end