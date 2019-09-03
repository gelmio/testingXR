require 'rubygems'
require 'httparty'
require 'feedjira'

class Jekyll::AtomReader < Liquid::Tag
  VALID_SYNTAX = %r!
    ([\w-]+)\s*=\s*
    (?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w\.-]+))
  !x
  VARIABLE_SYNTAX = /
    (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
    (?<params>.*)
  /x

  def syntax_example
    "{% #{@tag_name} %}"
  end

  def initialize(tag_name, markup, tokens)
    @params = markup
    super
  end

  def bind_params(context, str)
    params = {}
    while (match = VALID_SYNTAX.match(str))
      str = str[match.end(0)..-1]
      value = if match[2]
                match[2].gsub(%r!\\"!, '"')
              elsif match[3]
                match[3].gsub(%r!\\'!, "'")
              elsif match[4]
                context[match[4]]
              end
      params[match[1]] = value
    end
    params
  end

  def render(context)
    site = context.registers[:site]
    return unless site.config['atom_reader_fetch'] == true
    params = bind_params(context, @params)
    url   = params['url'].to_s
    limit = params['limit'].to_i
    _body = params['body'].to_s

    unless url.empty?
      puts "Fetching feed for " + url
      xml    = HTTParty.get(url).body
      feed   = Feedjira.parse(xml)
      _items = feed.entries
      title  = ""

      unless params['title'] == "0"
        if params['title'] == ""
          title = feed.title if feed.title
        else
          title = params['title']
        end
      end

      template = params['template'] || 'atom-reader'
      path     = File.join(site.source, '_includes') + '/' + template
      content  = File.read(path)
      partial  = site.liquid_renderer.file(path).parse(content)

      items = []
      limit.to_i.times do |i|
        next unless _items[i]
        item = _items[i]
        body = case _body
               when "content"
                 item.content
               when "summary"
                 item.summary
               end
        items << {
          'title' => item.title.to_s.force_encoding("utf-8"),
          'body' => body.to_s.force_encoding("utf-8"),
          'published' => item.published.to_s.force_encoding("utf-8"),
          'url' => item.url.to_s.force_encoding("utf-8"),
          'image' => item.image
        }
      end

      context.stack do
        context['feed'] = {'title' => title,
                           'items' => items}
        partial.render!(context)
      end
    else
      "no url provided"
    end
  end
end

Liquid::Template.register_tag('atom_read', Jekyll::AtomReader)
