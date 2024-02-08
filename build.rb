#!/usr/bin/env ruby

$blog_title = 'Tanguy Andreani'
$post_list = 'Contenu'
$default_post_title = 'please give me a title'
$output_dir = './docs'

require 'fileutils'
FileUtils.mkdir_p $output_dir

require 'psych'
require 'date'

require 'kramdown'
require 'rouge'

require './from_jekyll_project'

filenames = Dir["*.markdown"]

$build_drafts = ARGV.include? "--enable-drafts"

$html_doctype = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
'''

$html_katex = '''
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" integrity="sha384-n8MVd4RsNIU0tAv4ct0nTaAbDJwPJzDEaqSD1odI+WdtXRGWt2kTvGFasHpSy3SV" crossorigin="anonymous">

<!-- The loading of KaTeX is deferred to speed up page rendering -->
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" integrity="sha384-XjKyOOlGwcjNTAIQHIpgOno0Hl1YQqzUOEleOLALmuqehneUG+vnGctmUb0ZY0l8" crossorigin="anonymous"></script>

<!-- To automatically render math in text elements, include the auto-render extension: -->
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" integrity="sha384-+VBxd3r6XgURycqtZ117nYw44OOcIax56Z4dCRWbxyPt0Koah1uHoK0o4+/RRE05" crossorigin="anonymous"
    onload="renderMathInElement(document.body);"></script>
'''

$html_open_body = '''
</head><body>
'''

$html_link_to_index = '''
<div class="home-link">
  <a href="/">← index</a>
</div>
'''

$html_footer = '''
<footer>
    <p><i>Inspiré du blog de <a href="https://fabiensanglard.net/">Fabien Sanglard</a>.</i></p>
</footer>
'''

$html_close_tags = '''
</body></html>
'''

index = []

def link_href css_file
  "<link rel=\"stylesheet\" href=\"#{css_file}\" />"
end

def write_html filename, front_matter, markdown
  front_matter['permalink'] ||= filename.gsub(/\.markdown$/, '.html')
  front_matter['title'] ||= $default_post_title

  html = html_from_markdown_file filename, front_matter, markdown
  
  File.open($output_dir + '/' + front_matter['permalink'], 'w') { |l|
    l.write(html)
  }
end

def html_from_markdown_file filename, front_matter, markdown
  content = $html_doctype.dup

  content << link_href('typesafe.css')
  content << link_href('pandoc.css')
  content << link_href('algol.css')
  
  content << "<title>#{front_matter['title']} - #{$blog_title}</title>"
  
  if filename != './index.markdown'
  else
    content << link_href('./index.css')
  end

  if front_matter['mathjax']
    content << $html_katex
  end

  content << $html_open_body

  if filename != './index.markdown'
    content << $html_link_to_index

    # title and date
    content << """
      <header id=\"title-block-header\">
        <h1 class=\"title\">#{front_matter['title']}</h1>
        <p class=\"date\">#{front_matter['date']}</p>
      </header>
    """
  end

  content << Kramdown::Document.new(markdown, syntax_highlighter: :rouge).to_html 
  

  content << $html_footer
  content << $html_close_tags

  content
end

# Generate every pages

filenames.each { |filename|
  next if filename == 'index.markdown'

  puts "Processing #{filename}"

  data, content = get_front_matter filename
  
  if data['draft'] && !$build_drafts
    next
  end

  index << {
    filename: filename,
    draft: data['draft'],
    date: data['date'],
    title: data['title'],
    permalink: data['permalink']
  }
  
  write_html filename, data, content
}

# Generate index.markdown

index.sort_by! { |page|
  page[:date]
}.reverse!

File.open("./index.markdown","w") do |line|
  line.puts """---
title: #{$post_list}
permalink: ./index.html
---
  """

  index.each { |page|
    b, e = '', ''
    if page[:draft]
      b = '<span class="draft-link">'
      e = '</span>'
    end
    line.puts "- #{page[:date].to_s.gsub(/-/, '/')}: #{b}[#{page[:title]}](#{page[:permalink]})#{e}\n"
  }
end

# Generate index.html

puts "Processing index.markdown"
index_front_matter, index_content = get_front_matter './index.markdown'
write_html './index.markdown', index_front_matter, index_content

exit 0