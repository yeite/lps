---
layout: default
title: "00 Lista de Años"
permalink: /anos/
---

<section class="posts">
  <div class="flex-row-between">
    <h1>Películas por año</h1>
    <a href="{{ site.url }}{{ site.baseurl }}"><i class="fa fa-home" aria-hidden="true"></i> Inicio</a>
  </div>

  <ul>
    {% assign years = site.posts | map: 'year' | uniq | sort %}
    {% for year in years %}
      {% assign count = site.posts | where: "year", year | size %}
      <li>
        <a href="{{ site.baseurl }}/year/{{ year }}/">{{ year }}</a> ({{ count }})
      </li>
    {% endfor %}
  </ul>
</section>