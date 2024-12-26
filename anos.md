---
layout: default
title: "Lista de Años"
permalink: /anos/
---

<h1>Lista de Películas por Año</h1>
<ul>
  {% assign years = site.posts | map: 'year' | uniq | sort %}
  {% for year in years %}
    <li><a href="{{ site.baseurl }}/year/{{ year }}/">{{ year }}</a></li>
  {% endfor %}
</ul>