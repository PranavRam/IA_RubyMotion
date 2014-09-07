class IAAlbumTableViewCell < UITableViewCell
  extend IB

  outlet :album_image_view
  outlet :album_title_label

  def setFromAlbum(album)
    album_image_view.image = UIImage.imageWithCGImage(album.posterImage)
    album_title_label.text = album.valueForProperty(ALAssetsGroupPropertyName)
  end
end