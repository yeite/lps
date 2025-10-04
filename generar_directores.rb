require 'fileutils'
require 'yaml'

posts_dir = "_posts"
directores_dir = "_directores"

FileUtils.mkdir_p(directores_dir)
directores = []

def slugify(text)
  text = text.downcase.strip
  text = text.unicode_normalize(:nfkd).gsub(/\p{Mn}/, '')
  text.gsub(/[^a-z0-9\-]+/, '-').gsub(/^-|-$/, '')
end

Dir.glob("#{posts_dir}/*.{md,markdown}") do |post_path|
  content = File.read(post_path)

  if content =~ /---(.*?)---/m
    begin
      front_matter = YAML.safe_load($1)
      if front_matter.is_a?(Hash) && front_matter["director"]
        front_matter["director"]
          .split(/[,;]+/)
          .map(&:strip)
          .reject(&:empty?)
          .each do |d|
            directores << d
          end
      end
    rescue Psych::SyntaxError => e
      puts "⚠️ Error en #{post_path}: #{e.message}"
    end
  end
end

directores.uniq.each do |director|
  slug = slugify(director)
  path = "#{directores_dir}/#{slug}.md"

  File.open(path, "w") do |f|
    f.puts "---"
    f.puts "layout: director"
    f.puts "title: #{director}"   # se ve en la página
    f.puts "director: #{director}"
    f.puts "slug: #{slug}"        # se usa para enlaces
    f.puts "---"
  end

  puts "✅ creado: #{path}"
end

puts "🎬 Se generaron #{directores.uniq.count} directores."
