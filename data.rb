$html_doctype = '
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
'

$html_katex = '
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" integrity="sha384-n8MVd4RsNIU0tAv4ct0nTaAbDJwPJzDEaqSD1odI+WdtXRGWt2kTvGFasHpSy3SV" crossorigin="anonymous">

<!-- The loading of KaTeX is deferred to speed up page rendering -->
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" integrity="sha384-XjKyOOlGwcjNTAIQHIpgOno0Hl1YQqzUOEleOLALmuqehneUG+vnGctmUb0ZY0l8" crossorigin="anonymous"></script>

<!-- To automatically render math in text elements, include the auto-render extension: -->
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" integrity="sha384-+VBxd3r6XgURycqtZ117nYw44OOcIax56Z4dCRWbxyPt0Koah1uHoK0o4+/RRE05" crossorigin="anonymous"
    onload="renderMathInElement(document.body);"></script>
'

$html_open_body = '</head><body>'

$html_link_to_index = '
<div class="home-link">
  <a href="/">🏠</a>
</div>
'

$html_footer = '
<footer>
    <p><i>
      Inspiré des blogs de <a href="https://fabiensanglard.net/">Fabien Sanglard</a>
      et <a href="https://jvns.ca/">Julia Evans</a>.</i>
'

$html_footer_close = '
  </p>
</footer>
'

$hosmas_filter = "
<script>
const input = document.querySelector('input')
const ps = document.querySelectorAll('li')
const hs = document.querySelectorAll('h1')
input.onkeyup = () => {

  var i = 0;
  ps.forEach(p => {
    i++
    p.hidden = i > 5 && !p.innerText.toLowerCase().includes(input.value.toLowerCase())
  })


  var j = 0;
  hs.forEach(h => {
    j++;
    if (j == 1) return;
    var ul = h.nextSibling;
    while (ul.nodeName != 'UL') {
      ul = ul.nextSibling
    }
    h.hidden = [].slice.call(ul.children).reduce((acc, curr) => {return (acc && curr.hidden)}, 1)
  })
}
</script>
"

$html_close_tags = '
</body></html>
'

$toc = '
<div class="toc-btn"><span>toc</span></div>
'
