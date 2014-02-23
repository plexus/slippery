[![Gem Version](https://badge.fury.io/rb/slippery.png)][gem]
[![Build Status](https://secure.travis-ci.org/plexus/slippery.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/plexus/slippery.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/plexus/slippery.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/plexus/slippery/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/slippery
[travis]: https://travis-ci.org/plexus/slippery
[gemnasium]: https://gemnasium.com/plexus/slippery
[codeclimate]: https://codeclimate.com/github/plexus/slippery
[coveralls]: https://coveralls.io/r/plexus/slippery

#Slippery

Marries the flexible [Kramdown](https://kramdown.rubyforge.org) parser for Markdown with the flexibility of DOM manipulation with [Hexp](https://github.com/plexus/hexp) to generate HTML slides backed by either Reveal.js or Impress.js.

Because Slippery slides are the best slides.

## How to use

Create a markdown file, say `presentation.md`, that will be the source of your presentation. use `---` to separate slides.

In the same directory, create a Rakefile, the most basic form is :

```ruby
require 'slippery'

Slippery::RakeTasks.new
```

Slippery will detect and markdown files in the current directory, and generate rake tasks for them.

```
rake slippery:build               # build all
rake slippery:build:presentation  # build presentation
```


You can use a block to configure Slippery:

```ruby
require 'slippery'

Slippery::RakeTasks.new do |s|
  s.options = {
    type: :reveal_js,
    theme: 'beige',
    controls: false,
    backgroundTransition: 'slide',
    history: true,
    plugins: [:notes]
  }

  s.processor 'head' do |head|
    head <<= H[:title, 'Web Services, Past Present Future']
  end
end
```

After converting your presentation from Markdown, you can use Hexp to perform transformations on the result. This is what happens with the `processor`, you pass it a CSS selector, each matching element gets passed into the block, and replaced by whatever the block returns. See the [Hexp](http://github.com/plexus/hexp) DSL for details.

You can also add built-in or custom processors directly

```ruby
Slippery::RakeTasks.new do |s|
  s.processors << Slippery::Processors::GraphvizDot.new('.dot')
  s.processors << Slippery::Processors::SelfContained
end
```

## Processors

These are defined in the `Slippery::Processors` namespace.

### GraphvizDot

The "Dot" language is a DSL (domain specific language) for describing graphs. Using the `GraphvizDot` processor, you can turn "dot" fragments into inline SVG graphics.

In your presentation :

    ````dot
    graph dependencies {
      node[shape=circle color=blue]
      edge[color=black penwidth=3]

      slippery[fontcolor=red];

      slippery -> hexp -> equalizer;
      slippery -> kramdown;
      hexp -> ice_nine;
    }
    ````

In the Rakefile

```ruby
Slippery::RakeTasks.new do |s|
  s.processors << Slippery::Processors::GraphvizDot.new('.dot')
  s.processors << Slippery::Processors::SelfContained
end
```

And the result:

<svg width="305pt" height="432pt"
 viewBox="0.00 0.00 305.00 432.00" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<g id="graph1" class="graph" transform="scale(1 1) rotate(0) translate(4 428)">
<title>dependencies</title>
<polygon fill="white" stroke="white" points="-4,5 -4,-428 302,-428 302,5 -4,5"/>
<!-- slippery -->
<g id="node1" class="node"><title>slippery</title>
<ellipse fill="none" stroke="blue" cx="176" cy="-369" rx="53.9477" ry="54.4472"/>
<text text-anchor="middle" x="176" y="-365.4" font-family="Times Roman,serif" font-size="14.00" fill="red">slippery</text>
</g>
<!-- hexp -->
<g id="node3" class="node"><title>hexp</title>
<ellipse fill="none" stroke="blue" cx="118" cy="-214" rx="34.8574" ry="35.3553"/>
<text text-anchor="middle" x="118" y="-210.4" font-family="Times Roman,serif" font-size="14.00">hexp</text>
</g>
<!-- slippery&#45;&gt;hexp -->
<g id="edge2" class="edge"><title>slippery&#45;&gt;hexp</title>
<path fill="none" stroke="black" stroke-width="3" d="M156.848,-317.818C149.486,-298.144 141.164,-275.903 134.115,-257.067"/>
<polygon fill="black" stroke="black" points="137.34,-255.699 130.558,-247.56 130.784,-258.152 137.34,-255.699"/>
</g>
<!-- kramdown -->
<g id="node6" class="node"><title>kramdown</title>
<ellipse fill="none" stroke="blue" cx="234" cy="-214" rx="63.1385" ry="63.6396"/>
<text text-anchor="middle" x="234" y="-210.4" font-family="Times Roman,serif" font-size="14.00">kramdown</text>
</g>
<!-- slippery&#45;&gt;kramdown -->
<g id="edge5" class="edge"><title>slippery&#45;&gt;kramdown</title>
<path fill="none" stroke="black" stroke-width="3" d="M195.152,-317.818C199.302,-306.726 203.758,-294.819 208.119,-283.166"/>
<polygon fill="black" stroke="black" points="211.524,-284.053 211.75,-273.46 204.968,-281.6 211.524,-284.053"/>
</g>
<!-- equalizer -->
<g id="node4" class="node"><title>equalizer</title>
<ellipse fill="none" stroke="blue" cx="56" cy="-57" rx="56.0679" ry="56.5685"/>
<text text-anchor="middle" x="56" y="-53.4" font-family="Times Roman,serif" font-size="14.00">equalizer</text>
</g>
<!-- hexp&#45;&gt;equalizer -->
<g id="edge3" class="edge"><title>hexp&#45;&gt;equalizer</title>
<path fill="none" stroke="black" stroke-width="3" d="M104.851,-180.704C97.7925,-162.829 88.8602,-140.211 80.5698,-119.217"/>
<polygon fill="black" stroke="black" points="83.7433,-117.724 76.8149,-109.709 77.2326,-120.295 83.7433,-117.724"/>
</g>
<!-- ice_nine -->
<g id="node8" class="node"><title>ice_nine</title>
<ellipse fill="none" stroke="blue" cx="181" cy="-57" rx="51.1176" ry="51.6188"/>
<text text-anchor="middle" x="181" y="-53.4" font-family="Times Roman,serif" font-size="14.00">ice_nine</text>
</g>
<!-- hexp&#45;&gt;ice_nine -->
<g id="edge7" class="edge"><title>hexp&#45;&gt;ice_nine</title>
<path fill="none" stroke="black" stroke-width="3" d="M131.207,-181.088C138.973,-161.733 149.01,-136.72 158.036,-114.228"/>
<polygon fill="black" stroke="black" points="161.357,-115.35 161.833,-104.766 154.86,-112.744 161.357,-115.35"/>
</g>
</g>
</svg>
