class IAViewController < UIViewController

  def launchImagePicker(sender)
    picker = UIImagePickerController.new
    picker.delegate = self
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(picker.sourceType)

    presentViewController(picker, animated:true, completion:nil)
  end

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info)
    picker.dismissViewControllerAnimated(true, completion:nil)
    if picker.sourceType == UIImagePickerControllerSourceTypeCamera
      saveMediaThenViewAsset(info)
    else
      assetURL = info[UIImagePickerControllerReferenceURL]
      viewAssetFromURL(assetURL)
    end
  end

  def prepareForSegue(segue, sender:sender)
    segue.destinationViewController.asset_url = sender
  end

  def launchCamera(sender)
    if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera))
      alert = UIAlertView.alloc.initWithTitle("Sorry", message: "No camera available", delegate: nil, cancelButtonTitle: "Okay", otherButtonTitles: nil, nil)
      alert.show
    else
      picker = UIImagePickerController.new
      picker.delegate = self
      picker.sourceType = UIImagePickerControllerSourceTypeCamera
      picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(picker.sourceType)
      picker.videoQuality = UIImagePickerControllerQualityTypeHigh
      picker.videoMaximumDuration = 300
      presentViewController(picker, animated: true, completion: nil )
    end
  end

  def saveMediaThenViewAsset(info)
    mediaType = info[UIImagePickerControllerMediaType]
    if mediaType == KUTTypeImage
      image = info[UIImagePickerControllerOriginalImage]
      IAAssetsLibrary.default_instance.writeImageToSavedPhotosAlbum(image.CGImage, orientation: image.imageOrientation, 
        completionBlock: lambda do |assetURL, error|
          viewAssetFromURL(assetURL)  
      end)
    elsif mediaType == KUTTypeVideo
      mediaURL = info[UIImagePickerControllerMediaURL]
      IAAssetsLibrary.default_instance.writeVideoAtPathToSavedPhotosAlbum(mediaURL, 
        completionBlock:lambda do |assetURL, error|
          viewAssetFromURL(assetURL)
      end)
    end
  end

  def viewAssetFromURL(assetURL)
    performSegueWithIdentifier("assetView", sender:assetURL)
  end
end