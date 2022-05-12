#!/usr/bin/env ruby

=begin
(The code in this file which handles YAML front matters belongs to the Jekyll
static site generator.)

The MIT License (MIT)

Copyright (c) 2008-present Tom Preston-Werner and Jekyll contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
=end

$blog_title = 'Tanguy Andreani'
$post_list = 'Posts'
$default_post_title = 'please give me a title'

require 'psych'
require 'date'

YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m.freeze

filenames = Dir["*.markdown"]

$build_drafts = ARGV.include? "--enable-drafts"

index = []

def get_front_matter filename
  content = ''
  data = {}
  
  begin
    content = File.read(filename)
    if content =~ YAML_FRONT_MATTER_REGEXP
      #content = Regexp.last_match.post_match
      data = Psych.safe_load(Regexp.last_match(1), permitted_classes: [Date])
    end
  rescue Psych::SyntaxError => e
    $stderr.puts "YAML Exception reading #{filename}: #{e.message}"
    raise e
  rescue StandardError => e
    $stderr.puts "Error reading file #{filename}: #{e.message}"
    raise e
  end

  [data, ''] # empty string used to be `content`
end

def pandoc_command_for filename, front_matter, content
  data = front_matter

  data['permalink'] ||= filename.gsub(/\.markdown$/, '.html')
  data['title'] ||= $default_post_title

  options = []
  options << 'pandoc'
  options << '-s'
  
  if data['mathjax']
    options << '--mathjax'
    options << '-H mathjax.html'
  end

  options << '-c typesafe.css -c pandoc.css -A footer.html'
  
  options << '-B header.html'

  if filename != './index.markdown'
    #options << '--toc'
  else
    options << '-c index.css'
  end
  
  options << "--metadata pagetitle=\"#{data['title']} - #{$blog_title}\""
  
  options << "\"#{filename}\" -o \"#{data['permalink']}\""
  
  options.join(' ')
end

filenames.each { |filename|
  next if filename == 'index.markdown'

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
  
  command = pandoc_command_for filename, data, content
  puts command
  print `#{command} 2>&1`
}

index.sort_by! { |page|
  page[:date]
}.reverse!

File.open("./index.markdown","w") do |line|
  line.puts """---
title: #{$post_list}
permalink: index.html
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

data, content = get_front_matter './index.markdown'
command = pandoc_command_for './index.markdown', data, content
puts command
print `#{command} 2>&1`

exit 0