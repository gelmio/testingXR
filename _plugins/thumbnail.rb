# Generates a thumbnail to an image and renders an image tag.

require 'mini_magick'

class Jekyll::Thumbnail < Liquid::Tag
  VARIABLE_SYNTAX = /
          (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
          (?<params>.*)
  /x

  def initialize(tag_name, markup, tokens)
    if /(?<style>[^\s]+)\s+(?<source>[^\s]+)\s+(?<size>[^\s]+)\s+(?<crop>[^\s]+)/i =~ markup
      @style   = style
      @crop    = crop
      @source  = source
      @size    = size
    end
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
    if @source
      page = context.registers[:page]
      site = context.registers[:site]
      if File.basename(page['path']) == "#excerpt"
        return
      end

      source  = render_variable(context, @source) || @source
      size    = render_variable(context, @size) || @size
      crop    = render_variable(context, @crop) || @crop
      root    = site.source

      # not an absolute path from jekyll root
      # so it's relative to post file directory
      if !source.start_with?("/")
        base_gallery_path = File.dirname page['path']
        dest_url = File.dirname(File.dirname(page.url) + "/" + source)
        source = "/#{base_gallery_path}/#{source}"
      end

      source_path = "#{root}#{source}"
      raise "#{source_path} is not readable" unless File.readable?(source_path)
      ext = File.extname(source)
      desc = size.gsub(/[^\da-z]+/i, '')
      dest_dir = "#{File.dirname(source_path)}/thumbs"
      Dir.mkdir dest_dir unless Dir.exists? dest_dir
      dest = "#{dest_dir}/#{File.basename(source, ext)}_#{desc}#{@style}#{ext}"

      if dest_url.to_s.empty?
        imgsrc = "#{File.dirname(source)}/thumbs/#{File.basename(source, ext)}_#{desc}#{@style}#{ext}"
      else
        imgsrc = "#{dest_url}/thumbs/#{File.basename(source, ext)}_#{desc}#{@style}#{ext}"
      end

      dest_path = "#{dest}"

      # only thumbnail the image if it doesn't exist tor is less recent than the source file
      # will prevent re-processing thumbnails for a ton of images...
      if !File.exists?(dest_path) || File.mtime(dest_path) <= File.mtime(source_path)
        # don't generate images in preview mode whenever possible
        if ENV['OCTOPRESS_ENV'] == 'preview' && /(?<width>\d+)?x(?<height>\d+)?/ =~ size
          html = "<img src='#{source}' style='"
          html << "max-width: #{width}px; " unless width.nil? || width.empty?
          html << "max-height: #{height}px;" unless height.nil? || height.empty?
          html << "' />"
          return html
        end

        puts "Thumbnailing #{File.basename(source)} to #{dest_dir} (#{@style} #{size} #{crop})"

        image = MiniMagick::Image.open(source_path)
        image.strip
        if @style == "resize"
          image.resize size
        else
          if @style == "crop"
            image.resize size
            image.crop crop
          end
        end
        image.write dest_path
      end

      """#{imgsrc}"""

    # TODO support relative paths
    else
      "Could not create thumbnail for #{source}. Usage: thumbnail /path/to/local/image.png 50x50<"
    end
  end
end

Liquid::Template.register_tag('thumbnail',   Jekyll::Thumbnail)
