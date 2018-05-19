//
//  BaseViewController.swift
//  CropDemo
//
//  Created by Hitendra Bhoir on 23/03/18.
//  Copyright © 2018 Hitendra Bhoir. All rights reserved.
//

import UIKit
import CropViewController
import MobileCoreServices
class BaseViewController:UIViewController, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    
    var isUsedImageCroper : String?
    private var croppingStyle = CropViewCroppingStyle.default
    
    private var croppedRect = CGRect.zero
    
    private var croppedAngle = 0
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoURL = info[UIImagePickerControllerMediaURL] as? URL
        {
            print("videoURL:\(String(describing: videoURL))")
            self.getVideo(videoUrl: videoURL)
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        if isUsedImageCroper != nil
        {
            
              self.getImage(image: image)
              self.dismiss(animated: true, completion: nil)
            
        }
        else
        {
        
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        //cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        //cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        
        cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
        cropController.setAspectRatioPreset(.preset16x9, animated: true)
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        cropController.resetAspectRatioEnabled = false
        cropController.cropView.cropBoxResizeEnabled = false
        
        
      
        cropController.cropView.gridOverlayView.displayHorizontalGridLines = false
        cropController.cropView.gridOverlayView.displayVerticalGridLines = false
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            
            cropController.setAspectRatioPreset(.presetSquare, animated: true)
            picker.pushViewController(cropController, animated: true)
        }
        else { //otherwise dismiss, and then present from the main controller
            //cropController.cropView.setAspectRatio(CGSize(width: 350, height: 147), animated: true)
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
        }
    }
    public func getImage(image : UIImage)  {
        
    }
    public func getVideo(videoUrl : URL)  {
        
    }
    public func getDocument(documentUrl : URL)  {
        
    }
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        
        
       
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if cropViewController.croppingStyle != .circular {
             self.getImage(image: image)
        }
        else
        {
            
             self.getImage(image: image)
        }
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    func selectImageANDPdf(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let gallery = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let pdf = UIAlertAction(title: "Choose PDF", style: .default) { (action) in
            self.croppingStyle = .default
            
            let types: NSArray = NSArray(object: kUTTypePDF as NSString)
            let documentPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            
        }
        
        /*
         let profileAction = UIAlertAction(title: "Make Profile Picture", style: .default) { (action) in
         self.croppingStyle = .circular
         
         let imagePicker = UIImagePickerController()
         imagePicker.modalPresentationStyle = .popover
         imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
         imagePicker.sourceType = .photoLibrary
         imagePicker.allowsEditing = false
         imagePicker.delegate = self
         self.present(imagePicker, animated: true, completion: nil)
         }
         */
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(pdf)
        
        alertController.addAction(cancel)
        //alertController.addAction(profileAction)
        alertController.modalPresentationStyle = .popover
        
        let presentationController = alertController.popoverPresentationController
        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
    }
    func addButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.croppingStyle = .default
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let gallery = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            
        }
        
        /*
         let profileAction = UIAlertAction(title: "Make Profile Picture", style: .default) { (action) in
         self.croppingStyle = .circular
         
         let imagePicker = UIImagePickerController()
         imagePicker.modalPresentationStyle = .popover
         imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
         imagePicker.sourceType = .photoLibrary
         imagePicker.allowsEditing = false
         imagePicker.delegate = self
         self.present(imagePicker, animated: true, completion: nil)
         }
         */
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancel)
        //alertController.addAction(profileAction)
        alertController.modalPresentationStyle = .popover
        
        let presentationController = alertController.popoverPresentationController
        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
    }
    func addButtonTappedForProfile(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Take Photo", style: .default) { (action) in
           self.croppingStyle = .circular
            
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .popover
            //imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let gallery = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            self.croppingStyle = .circular
            
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .popover
            //imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            
        }
        
        /*
         let profileAction = UIAlertAction(title: "Make Profile Picture", style: .default) { (action) in
         self.croppingStyle = .circular
         
         let imagePicker = UIImagePickerController()
         imagePicker.modalPresentationStyle = .popover
         imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
         imagePicker.sourceType = .photoLibrary
         imagePicker.allowsEditing = false
         imagePicker.delegate = self
         self.present(imagePicker, animated: true, completion: nil)
         }
         */
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancel)
        //alertController.addAction(profileAction)
        alertController.modalPresentationStyle = .popover
        
        let presentationController = alertController.popoverPresentationController
        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
    }
    
    func addImageWithAllOption(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraImage = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let galleryImage = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cameraVideo = UIAlertAction(title: "Make Video", style: .default) { (action) in
            self.croppingStyle = .default
            
            let mediaUI = UIImagePickerController()
            mediaUI.sourceType = .camera
            mediaUI.mediaTypes = [kUTTypeMovie as NSString as String]
            mediaUI.allowsEditing = false
            mediaUI.delegate = self
            self.present(mediaUI, animated: true, completion: nil)
        }
        let galleryVideo = UIAlertAction(title: "Choose Video", style: .default) { (action) in
                self.croppingStyle = .default
            
            let mediaUI = UIImagePickerController()
            mediaUI.sourceType = .savedPhotosAlbum
            mediaUI.mediaTypes = [kUTTypeMovie as NSString as String]
            mediaUI.allowsEditing = false
            mediaUI.delegate = self
            self.present(mediaUI, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            
        }
        
        /*
         let profileAction = UIAlertAction(title: "Make Profile Picture", style: .default) { (action) in
         self.croppingStyle = .circular
         
         let imagePicker = UIImagePickerController()
         imagePicker.modalPresentationStyle = .popover
         imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
         imagePicker.sourceType = .photoLibrary
         imagePicker.allowsEditing = false
         imagePicker.delegate = self
         self.present(imagePicker, animated: true, completion: nil)
         }
         */
        alertController.addAction(cameraImage)
        alertController.addAction(galleryImage)
        alertController.addAction(cameraVideo)
        alertController.addAction(galleryVideo)
        alertController.addAction(cancel)
        //alertController.addAction(profileAction)
        alertController.modalPresentationStyle = .popover
        let presentationController = alertController.popoverPresentationController
        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
    }
   
}
extension BaseViewController: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        self.getDocument(documentUrl: cico)
        print(cico)
        print(url)
        
        print(url.lastPathComponent)
        
        print(url.pathExtension)
        
    }
}



