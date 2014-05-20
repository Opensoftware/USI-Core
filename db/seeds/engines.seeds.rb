# Load Pyrite seeds
if defined?(Pyrite)
  load(File.join(Pyrite::Engine.root, "db", "seeds", "pyrite.rb"))
end
