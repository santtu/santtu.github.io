class Figure < ::Liquid::Block
  include Liquid::StandardFilters

  def initialize(tag_name, img_ref, tokens)
    @img_ref = img_ref
    super
  end

  def render(context)
    caption = super
    <<EOM.strip
<figure class="figure">
<img src="#{@img_ref}" alt="#{strip_html(caption)}">
<figcaption>#{caption}</figcaption>
</figure>
EOM
  end
end

#     raw_uri = "https://gist.github.com/raw/#{@gist_id}/#{@filename}"
#     script_uri = "https://gist.github.com/#{@gist_id}.js?file=#{@filename}"

#     <<MARKUP.strip
# <div id="gist-#{@gist_ref.gsub(/[^a-z0-9]/i,'-')}">
# <script src="#{script_uri}"></script>
# <noscript>
# <pre>#{CGI.escapeHTML(open(raw_gist_uri).read.chomp)}</pre>
# </noscript>
# </div>
# MARKUP

Liquid::Template.register_tag('figure', Figure)
