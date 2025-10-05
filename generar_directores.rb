require 'fileutils'
require 'yaml'

posts_dir = "_posts"
directores_dir = "_directores"

FileUtils.mkdir_p(directores_dir)

# Hash para guardar cada director y sus películas
directores_hash = Hash.new { |h, k| h[k] = [] }

# Función para generar slugs limpios (sin tildes ni caracteres raros)
def slugify(text)
  text = text.downcase.strip
  text = text.unicode_normalize(:nfkd).gsub(/\p{Mn}/, '') # elimina tildes
  text.gsub(/[^a-z0-9\-]+/, '-').gsub(/^-|-$/, '')
end

# Leer todos los posts
Dir.glob("#{posts_dir}/*.{md,markdown}") do |post_path|
  content = File.read(post_path)

  if content =~ /---(.*?)---/m
    begin
      front_matter = YAML.safe_load($1)
      next unless front_matter.is_a?(Hash) && front_matter["director"]

      # Generar URL correcta de Jekyll según el post
      filename = File.basename(post_path, ".*") # ej: "2025-08-18-puede-besar-al-esposo"
      year, month, day, *title_parts = filename.split("-")
      slug_post = title_parts.join("-")
      url = "#{year}/#{month}/#{day}/#{slug_post}/"

      # Separar directores por ',' o ';' y agregar la película
      front_matter["director"]
        .split(/[,;]+/)
        .map(&:strip)
        .reject(&:empty?)
        .each do |d|
          directores_hash[d] << {
            "title" => front_matter["title"] || "(Sin título)",
            "url"   => url
          }
        end
    rescue Psych::SyntaxError => e
      puts "⚠️ Error en #{post_path}: #{e.message}"
    end
  end
end

# Crear archivo individual por cada director
directores_hash.each do |director, peliculas|
  slug = slugify(director)
  path = "#{directores_dir}/#{slug}.md"

  # Generar contenido del archivo
  new_content = +"---\n"
  new_content << "layout: director\n"
  new_content << "title: #{director}\n"
  new_content << "slug: #{slug}\n"
  new_content << "peliculas:\n"
  peliculas.each do |p|
    new_content << "  - title: #{p['title'].inspect}\n"
    new_content << "    url: #{p['url'].inspect}\n"
  end
  new_content << "---\n"

  # Escribir solo si cambia (evita sobrescribir innecesariamente)
  if File.exist?(path)
    old_content = File.read(path)
    next if old_content == new_content
  end

  File.write(path, new_content)
  puts "✅ creado: #{path}"
end

puts "🎬 Se generaron #{directores_hash.keys.count} directores."
