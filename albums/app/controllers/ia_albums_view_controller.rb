class IAAlbumsViewController < UITableViewController
  attr_accessor :albums

  def load_albums
    library = IAAssetsLibrary.default_instance
    library.enumerateGroupsWithTypes(ALAssetsGroupAll, 
      usingBlock: lambda do |group, stop|
        if group
          albums.addObject(group)
        else
          tableView.performSelectorOnMainThread('reloadData', withObject: nil, waitUntilDone: true)
        end
      end,
      failureBlock: lambda do |error|
        NSLog("Problem loading albums: #{error}")
      end)
  end

  def viewDidLoad
    super
    @albums = Array.new
    load_albums
  end

  def tableView(tableView, numberOfRowsInSection: section)
    albums.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @cell_identifier = "albumCell"
    cell = tableView.dequeueReusableCellWithIdentifier(@cell_identifier)
    cell.setFromAlbum(albums[indexPath.row])
    cell
  end

  def tableView(tableView, canEditRowAtIndexPath: indexPath)
    true
  end

  def tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    if editingStyle == UITableViewCellEditingStyleDelete
      albums.removeObjectAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
    end
  end

  # def tableView(tableView, didSelectRowAtIndexPath: indexPath)
  #   cell = tableView.cellForRowAtIndexPath(indexPath)
  #   NSLog("Selected #{cell.album_title_label. text}")
  #   tableView.deselectRowAtIndexPath(indexPath, animated: true)
  # end
  
  def prepareForSegue(segue, sender: sender)
    selectedIndex = self.tableView.indexPathForSelectedRow
    album = self.albums[selectedIndex.row]
    segue.destinationViewController.album = album
    self.tableView.deselectRowAtIndexPath(selectedIndex, animated: true)    
  end
end