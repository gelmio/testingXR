module Jekyll

  class EmailTag < Liquid::Tag

    MAIL_TO = '&#109;&#97;&#105;&#108;&#116;&#111;&#58;'
    STYLE = 'unicode-bidi: bidi-override; direction: rtl;'

    VARIABLE_SYNTAX = /
          (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
          (?<params>.*)
         /x

    def render_variable(context, var)
      return unless var.match(VARIABLE_SYNTAX)
      partial = context.registers[:site]
                  .liquid_renderer
                  .file('(variable)')
                  .parse(var)
      return partial.render!(context)
    end

    def initialize(tag_name, text, tokens)
      super
      @email = text
    end

    def render(context)
      # We can't encode just once. Reversal of html entities will
      # not work as expected.
      email = render_variable(context, @email) || @email
      reversed = encode(email.each_char.to_a.reverse.join)
      obfuscated = encode(email)
      "<script type=\"text/javascript\">" +
      " document.write('<a style=\"#{STYLE}\" href=\"#{MAIL_TO}#{obfuscated}\">#{reversed}</a>');" +
      "</script>"
    end

    private
    def encode(str)
      str = str.gsub('@', '&#64;')
      str = str.gsub('.', '&#46;')
    end
  end
end

Liquid::Template.register_tag('email', Jekyll::EmailTag)
