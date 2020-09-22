//
//  BWFeedbackViewController.swift
//  IssueReport
//
//  Created by raj on 18/09/20.
//

import UIKit
import IBAnimatable
import AVKit
import CoreServices
import iOSPhotoEditor


internal class  BWFeedbackViewController: UIViewController {
    
    // MARK: Variables
    
    private var imagePicker = UIImagePickerController()
    @IBOutlet var imgReport: UIImageView!
    @IBOutlet var txtReport: AnimatableTextView!
    @IBOutlet var btnAdd: AnimatableButton!
    @IBOutlet var btnEdit: AnimatableButton!
    var isImageChanged : Bool = false
    var isVideo : Bool = false
    var project_id = String()
    var videoURL = NSURL()
    private var bwfeedbackModel: BWFeedbackModel = BWFeedbackModel()
    
    // MARK: Setup
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    
    
    private func setup() {
        title = "Report a Problem"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(send))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismiss))
    }
    
    
    @objc private func handleDismiss() {
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc private func send() {
        
        if (self.txtReport.text?.isEmpty)!{
            displayTost(strMessage: "Please add description about your issue.")
            return
        }
        
        if self.imgReport.image != nil {
            let info = "Device: \(self.bwfeedbackModel.deviceModel)\n" + "iOS: \(self.bwfeedbackModel.deviceOs)\n" + "App Name: \(self.bwfeedbackModel.appName)\n" + "App Version: \(self.bwfeedbackModel.appVersion)\n" + "App Build: \(self.bwfeedbackModel.appBuild)\n"
            print(info)
            print(self.txtReport.text as Any)
            print(self.imgReport.image as Any)
            
            let dict = ["image": self.imgReport.image as Any,
                        "info": info,
                        "subject":self.txtReport.text as Any,
                        "project_id":project_id,
                        "videoURL":self.videoURL,
                        "isVideo":self.isVideo] as [String: AnyObject]
            
            BWWebAPI.sharedService.uploadMedia(dict) { (result) in
                print(result)
                self.dismiss(animated: true) {
                    
                }
            } onFailure: { (Error) in
                print(Error.localizedDescription)
            }
        }else{
            displayTost(strMessage: "Please select media.")
        }
        
        
    }
    
    @IBAction func btnAddimageAction(_ sender: Any) {
        self.openMedia()
    }
    
    @IBAction func btnEditimageAction(_ sender: Any) {
        
        if isImageChanged == true && self.imgReport.image != nil{
            let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
            photoEditor.photoEditorDelegate = self
            photoEditor.image = self.imgReport.image
            photoEditor.hiddenControls = [.crop, .share, .sticker , .save]
            photoEditor.colors = [.red, .white, .purple,.green, .magenta, .blue, .yellow, .brown, .cyan, .darkGray, .lightGray,.black, .orange]
            photoEditor.modalPresentationStyle = .fullScreen
            present(photoEditor, animated: true, completion: nil)
        }else{
            displayTost(strMessage: "Please select media.")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated:true, completion: nil) //5
    }
    
    func thumbnailFromVideoPath(_ path: URL) -> UIImage {
        let asset = AVURLAsset(url: path, options: nil)
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        var actualTime = CMTimeMake(value: 0, timescale: 0)
        let image: CGImage
        do {
            image = try gen.copyCGImage(at: time, actualTime: &actualTime)
            let thumbnail = UIImage(cgImage: image)
            return thumbnail
        } catch { }
        return UIImage()
    }
    
}

extension BWFeedbackViewController: PhotoEditorDelegate{
    
    func doneEditing(image: UIImage) {
        self.imgReport.image = image
        self.isImageChanged = true
        self.isVideo = false
    }
    
    func canceledEditing() {
        self.dismiss(animated: true) {
        }
    }
}


extension BWFeedbackViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func openMedia() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes  = ["public.image" , "public.movie"]
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard info[UIImagePickerController.InfoKey.mediaType] != nil else { return }
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeImage:
            self.dismiss(animated: true) {
                if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.imgReport.image = chosenImage
                    self.isImageChanged = true
                    self.isVideo = false
                }
            }
            break
        case kUTTypeMovie:
            if let mediaURL =  info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                let img = self.thumbnailFromVideoPath(mediaURL.absoluteURL)
                self.dismiss(animated: true) {
                    DispatchQueue.main.async {
                        self.imgReport.image = img
                        self.videoURL = mediaURL.absoluteURL as NSURL
                        self.isVideo = true
                    }
                }
            }
            break
        default:
            dismiss(animated: true, completion: nil)
            print("something else")
            break
        }
    }
}
