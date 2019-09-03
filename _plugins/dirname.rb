class Jekyll::Dirname < Liquid::Tag
  VARIABLE_SYNTAX = /
          (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
          (?<params>.*)
  /x

  def initialize(tag_name, url, tokens)
    @url = url
    super
  end

  def render_variable(context, var)
        return unless var.match(VARIABLE_SYNTAX)

        partial = context.registers[:site]
                         .liquid_renderer
                         .file('(variable)')
                         .parse(var)
        return partial.render!(context)
  end

  def render(context)
    if @url
      url = render_variable(context, @url) || @url
      dir = File.dirname(url)
      """#{dir}"""
    else
      "no url provided"
    end
  end
end

Liquid::Template.register_tag('dirname',   Jekyll::Dirname)
