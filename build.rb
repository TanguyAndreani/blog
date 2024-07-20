#!/usr/bin/env ruby
# frozen_string_literal: true

if ENV['MY_JRUBY_DEBUG']
  require 'ruby-debug'
  debugger # rubocop:disable Lint/Debugger
end

BLOG_CONFIG = {
  title: 'Blog / Tanguy Andreani',
  post_list: 'Contenu',
  default_post_title: 'please give me a title',
  output_dir: './docs',
  build_drafts: ARGV.include?('--enable-drafts')
}.freeze

require 'fileutils'
FileUtils.mkdir_p(BLOG_CONFIG[:output_dir])

require 'psych'
require 'date'

require 'kramdown'
require 'rouge'

require './from_jekyll_project'

filenames = Dir['*.markdown']

require './data'

index = []

def link_href(css_file)
  "<link rel=\"stylesheet\" href=\"#{css_file}\" />"
end

def write_html(filename, front_matter, markdown)
  front_matter['permalink'] ||= filename.gsub(/\.markdown$/, '.html')
  front_matter['title'] ||= BLOG_CONFIG[:default_post_title]

  html = html_from_markdown_file(filename, front_matter, markdown)

  File.open("#{BLOG_CONFIG[:output_dir]}/#{front_matter['permalink']}", 'w') do |l|
    l.write(html)
  end
end

def html_from_markdown_file(filename, front_matter, markdown)
  content = $html_doctype.dup

  content << link_href('typesafe.css')
  content << link_href('pandoc.css')
  content << link_href('algol.css')

  content << "<title>#{front_matter['title']}</title>"

  if filename != './index.markdown'
    nil
  else
    content << link_href('./index.css')
  end

  content << $html_katex if front_matter['mathjax']

  content << $html_open_body

  if filename != './index.markdown'

    # title and date
    content << "
      <header id=\"title-block-header\">
        #{$html_link_to_index}
        <h1 class=\"title\">#{front_matter['title']}</h1>
        <p class=\"date\">#{front_matter['date']}</p>
      </header>
    "
  end

  content << Kramdown::Document.new(markdown, syntax_highlighter: :rouge).to_html

  content << $html_footer

  if filename != './index.markdown'
    content << ''"
    <a class=\"historylink\" href=\"https://github.com/TanguyAndreani/blog/blob/master/#{filename}\">Source code and history</a>
    "''
  end

  content << $hosmas_filter if filename == './index.markdown'
  content << $focus_on_slash if filename == './index.markdown'

  content << $html_footer_close

  content << $html_close_tags

  content
end

# Generate every pages

filenames.each do |filename|
  next if filename == 'index.markdown'

  puts "Processing #{filename}"

  data, content = get_front_matter(filename)

  next if data['draft'] && !BLOG_CONFIG[:build_drafts]

  index << {
    filename:,
    draft: data['draft'],
    date: data['date'],
    title: data['title'],
    permalink: data['permalink'],
    category: data['category']
  }

  write_html(filename, data, content)
end

# Generate index.markdown

index.sort_by! do |page|
  page[:date]
end.reverse!

def list_item(fd, page)
  b = ''
  e = ''
  if page[:draft]
    b = '<span class="draft-link">'
    e = '</span>'
  end
  fd.puts "- #{page[:date].to_s.gsub(/-/, '/')} ➡️ #{b}[#{page[:title]}](#{page[:permalink]})#{e}\n"
end

File.open('./index.markdown', 'w') do |fd|
  fd.puts "---
title: #{BLOG_CONFIG[:title]}
permalink: ./index.html
---
# #{BLOG_CONFIG[:title]}

"

  per_categories = {}

  index.each do |page|
    if page[:category]
      per_categories[page[:category]] ||= []
      per_categories[page[:category]] << page
    end
  end

  fd.puts '
  '

  index.first(5).each do |page|
    list_item fd, page
  end

  fd.puts '

*Sometimes I write in french sometimes in english, feel free to use a browser extension to translate on-the-fly.*
  Check out my [personal website](https://tanguyandreani.me). For any comment, [use email](mailto:hello@tanguyandreani.me)
  or reach out publicly on any social media.

  Most of this blog orbitates around concepts such as improvisation, story-telling and reverse-engineering.
  No AI is involved in the writing process.

  [Instagram](https://instagram.com/tanguy.andreani)
  [Bluesky](https://lmbdfn.bsky.social)
  [Twitter](https://twitter.com/lmbdfn)
  [GitHub](https://github.com/TanguyAndreani)
  [LinkedIn](https://fr.linkedin.com/in/tanguy-andreani-280318225)
  '

  fd.puts ''
  fd.puts '<input type="text" placeholder="Filter" name="searchField" />'

  per_categories.each do |k, v|
    fd.puts ''
    fd.puts "# #{k}"
    fd.puts ''

    v.each do |page|
      list_item fd, page
    end
  end
end

# Generate index.html

puts 'Processing index.markdown'
index_front_matter, index_content = get_front_matter('./index.markdown')
write_html('./index.markdown', index_front_matter, index_content)

exit 0
