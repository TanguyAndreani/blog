=begin
(The code in this file belongs to the Jekyll static site generator.
Here is a copy of the license.)

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

YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m.freeze

def get_front_matter filename
  content = ''
  data = {}
  
  begin
    content = File.read(filename)
    if content =~ YAML_FRONT_MATTER_REGEXP
      content = Regexp.last_match.post_match
      data = Psych.safe_load(Regexp.last_match(1), permitted_classes: [Date])
    end
  rescue Psych::SyntaxError => e
    $stderr.puts "YAML Exception reading #{filename}: #{e.message}"
    raise e
  rescue StandardError => e
    $stderr.puts "Error reading file #{filename}: #{e.message}"
    raise e
  end

  [data, content] # empty string used to be `content`
end