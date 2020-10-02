//
//  BWFeedbackViewController.swift
//  IssueReport
//
//  Created by Bluewhale-iOS-Team on 18/09/20.
//

import UIKit
import IBAnimatable
import AVKit
import CoreServices
import iOSPhotoEditor
import IQKeyboardManagerSwift
import Reachability
import SVProgressHUD
import MobileCoreServices

internal class  BWFeedbackViewController: UIViewController {
    
    // MARK: Variables
    
    @IBOutlet var imgReport: UIImageView!
    @IBOutlet var txtSubject: AnimatableTextField!
    @IBOutlet var txtReport: AnimatableTextView!
    @IBOutlet var btnAdd: AnimatableButton!
    @IBOutlet var btnEdit: AnimatableButton!
    
    var isImageChanged : Bool = false
    var isVideo : Bool = false
    var strProject_id = String()
    var strBuild_Number = String()
    var strDevice_Info = String()
    var strReportedBy = String()
    var strConnectiontype = String()
    var strEnvironment = String()
    var strTimeZone = String()
    var strFixed_version_id = String()
    var reachability: Reachability!
    var videoURL = NSURL()
    let hostNames = [nil, "google.com", "invalidhost"]
    var hostIndex = 0
    var internetConnection : Bool = false

    private var imagePicker = UIImagePickerController()
    private var bwfeedbackModel: BWFeedbackModel = BWFeedbackModel()
 
    // MARK: Setup
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startHost(at: 0)
        
    }
    
   private func setup() {
        title = "Report a Problem"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(send))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismiss))
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        strTimeZone = Calendar.current.timeZone.localizedName(for: .standard, locale: Locale(identifier: "en"))!
    }
    
    
    @objc private func handleDismiss() {
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc private func send() {
        
        if (self.txtSubject.text?.isEmpty)!{
            displayTost(strMessage: "Please add subject about your issue.")
            return
        }
        
        SVProgressHUD.show(withStatus: "Sending...")
        
        var dict = ["subject":self.txtSubject.text as Any,
                    "description":self.txtReport.text as Any,
                    "project_id":strProject_id,
                    "videoURL":self.videoURL,
                    "isVideo":self.isVideo,
                    "Build_Number":strBuild_Number,
                    "Device_Info":strDevice_Info,
                    "ReportedBy":strReportedBy,
                    "Connectiontype":strConnectiontype,
                    "Environment":strEnvironment,
                    "Fixed_version_id":strFixed_version_id,
                    "TimeZone":strTimeZone] as [String: AnyObject]
        
        if self.imgReport.image != nil && self.txtReport.text.isEmpty == false{
            dict["image"] = self.imgReport.image
            BWWebAPI.sharedService.uploadMediaNew(dict) { (result) in
                print(result)
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {}
                }
            } onFailure: { (Error) in
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {}
                }
            }
        }else{
            
            BWWebAPI.sharedService.createIssueNew(dict, token: "") { (result) in
                print(result)
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {}
                }
                
            } onFailure: { (Error) in
                print(Error.localizedDescription)
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {}
                }
            }
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
            if isVideo == false{
                displayTost(strMessage: "Please select media.")
            }
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
    
    
    // MARK: - Internet Connection Method
    //-----------------------------
    
    func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: true)
        startNotifier()
        
    }
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = try! Reachability(hostname: hostName)
        } else {
            reachability = try! Reachability()
        }
        self.reachability = reachability
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                self.updateLabelColourWhenReachable(reachability)
            }
            reachability?.whenUnreachable = { reachability in
                self.updateLabelColourWhenReachable(reachability)
            }
        } else {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reachabilityChanged(_:)),
                name: .reachabilityChanged,
                object: reachability
            )
        }
    }
    
    func startNotifier() {
        // print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            // print("Unable to start\nnotifier")
            return
        }
    }
    
    func stopNotifier() {
        // print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    func updateLabelColourWhenReachable(_ reachability: Reachability) {
        if reachability.connection == .wifi {
            strConnectiontype = "Wifi"
        }else if reachability.connection == .cellular{
            strConnectiontype = "Mobile Data"
        }else{
            strConnectiontype = "None"
        }
        
    }
    
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        updateLabelColourWhenReachable(reachability)
        
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
