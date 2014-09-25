class IAAssetInfoViewController < UIViewController
  extend IB

  outlet :image_view
  outlet :table_view

  attr_accessor :asset_url
  attr_accessor :asset
  attr_accessor :metadata

  KExif = "{Exif}"
  KTitle = :kTitle
  KValue = :kValue

  def viewDidLoad
    super
    @metadata = []
    retrieveAsset
  end

  def retrieveAsset
    IAAssetsLibrary.default_instance.assetForURL(asset_url, resultBlock:lambda do |asset|
      setupViewFromAsset(asset)
    end, failureBlock:lambda do |error|
      alert = UIAlertView.alloc.initWithTitle("Oops", message: "You couldn't load that asset", delegate: nil, cancelButtonTitle: "Okay", otherButtonTitles: nil, nil)
      alert.show
    end)
  end

  def setupViewFromAsset(asset)
    @asset = asset
    title = @asset.defaultRepresentation.filename
    image = UIImage.imageWithCGImage(@asset.defaultRepresentation.fullScreenImage)
    image_view.setImage(image)
    retrieveMetadata
  end

  def retrieveMetadata
    if @asset.valueForProperty(ALAssetPropertyType) == ALAssetTypePhoto
      retrievePhotoMetadata
    else
      retrieveVideoMetadata
    end
  end

  def retrievePhotoMetadata
    meta = @asset.defaultRepresentation.metadata
    exif = meta[KExif]
    exif.each do |key, value|
      if(value && !value.isKindOfClass(NSArray.class) && !value.isKindOfClass(NSDictionary.class))
        @metadata << {kTitle: key, kValue: "#{value}"}
      end
    end
    table_view.reloadData
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @metadata.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @@cell_identifier = "Cell"
    cell = tableView.dequeueReusableCellWithIdentifier(@@cell_identifier)
    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: @@cell_identifier)
    end
    data = @metadata[indexPath.row]

    cell.textLabel.text = data[KTitle]
    cell.detailTextLabel.text = data[KValue]
    cell
  end
end