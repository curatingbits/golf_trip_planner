module MarkdownHelper
  require 'redcarpet'

  # Renders Markdown text to sanitized HTML using Redcarpet
  def render_markdown(text)
    return "" if text.to_s.strip.empty?

    # Configure Redcarpet with desired options
    renderer = Redcarpet::Render::HTML.new(
      filter_html: false,
      no_images: false,
      no_links: false,
      no_styles: false,
      safe_links_only: true,
      with_toc_data: false,
      hard_wrap: true,
      link_attributes: { target: "_blank", rel: "noopener" }
    )

    markdown = Redcarpet::Markdown.new(renderer,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      superscript: true,
      underline: true,
      highlight: true,
      quote: true,
      footnotes: true
    )

    # Render markdown to HTML
    html = markdown.render(text)

    # Sanitize the HTML for security
    sanitize(html,
            tags: %w[p br strong em u i h1 h2 h3 h4 h5 h6 ul ol li a blockquote code pre table thead tbody tr th td sup sub mark del],
            attributes: %w[href target rel title])
  end
end
