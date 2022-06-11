module SchemaRegistry
  def self.loader
    @loader ||= Loader.new(schemas_root_path: File.expand_path('../../schemas', __dir__))
  end
end
