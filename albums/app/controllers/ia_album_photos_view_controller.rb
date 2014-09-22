class IAAlbumPhotosViewController < UICollectionViewController
  attr_accessor :album
  attr_accessor :photos

  def viewDidLoad
    super
    self.title = self.album.valueForProperty(ALAssetsGroupPropertyName)
    @photos = NSMutableArray.new
    loadPhotos
  end

  def loadPhotos
    album.enumerateAssetsUsingBlock(
        lambda do |result, index, stop|
          if(result && result.valueForProperty(ALAssetPropertyType) == ALAssetTypePhoto)
            photos.addObject(result)
          end
        end
      )

    self.collectionView.reloadData
  end

  def numberOfSectionsInCollectionView(collectionView)
    1
  end

  def collectionView(collectionView, numberOfItemsInSection: section)
    photos.count
  end

  def collectionView(collectionView, cellForItemAtIndexPath: indexPath)
    @@cell_identifier = "photoCell"
    cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(@@cell_identifier, forIndexPath:indexPath)

    asset = photos[indexPath.row]
    cell.image_view.image = UIImage.imageWithCGImage(asset.thumbnail)
    cell
  end

  def collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
    CGSizeMake(104.0, 104.0)
  end

  def collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAtIndex: section)
    2.0
  end

  def collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAtIndex: section)
    2.0
  end

  def collectionView(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: section)
    UIEdgeInsetsMake(2.0, 0.0, 2.0, 0.0)
    
  end
end