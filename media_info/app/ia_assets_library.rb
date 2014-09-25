class IAAssetsLibrary < ALAssetsLibrary
  
  def self.default_instance
    Dispatch.once { @singleton ||= new }
    @singleton
  end

end