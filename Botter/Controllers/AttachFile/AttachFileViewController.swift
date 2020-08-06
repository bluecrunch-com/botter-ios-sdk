//
//  AttachFileViewController.swift
//  Botter
//
//  Created by Nora on 7/27/20.
//  Copyright © 2020 BlueCrunch. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

class AttachFileViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    var actions = ["Camera" , "Gallary" , "File"]
    let imagepicker = UIImagePickerController()
    var completion : ((AttachedFile)->())!
    var loader = LoaderManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagepicker.delegate = self
        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    static func open(in parent:UIViewController , completion:@escaping((AttachedFile)->())){
        let content: ContentSheetContentProtocol
        let vc = AttachFileViewController.instantiateFromStoryBoard(appStoryBoard: .Main)
        vc.completion = { item in
            completion(item)
        }
        let contentController = vc
        content = contentController
        let contentSheet = ContentSheet(content: content)
        contentSheet.blurBackground = false
        contentSheet.showDefaultHeader = false
        contentSheet.dismissOnTouchOutside = false
        
        parent.present(contentSheet, animated: true, completion: nil)
        
    }
    
    override func collapsedHeight(containedIn contentSheet: ContentSheet) -> CGFloat {
           return 300
       }
       
       override func expandedHeight(containedIn contentSheet: ContentSheet) -> CGFloat {
           return 300
       }
    
    func showLoader() {
        self.loader.show(inRect: self.view.frame, inView: self.view)
    }
    
    func hideLoader() {
        self.loader.remove()
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            openGallary()
        case .denied, .restricted :
            //handle denied status
            galleryAccessDenied()
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    // as above
                    self.openGallary()
                case .denied, .restricted:
                    // as above
                    self.galleryAccessDenied()
                case .notDetermined:
                    // won't happen but still
                    break
                @unknown default:
                    break
                }
            }
        @unknown default:
            break
        }
    }
    
    func galleryAccessDenied(){
        let alert = UIAlertController(title: "Gallery", message: "Gallery access is necessary to pick your Media", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true)
    }
    
    func openGallary()
    {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)){
            self.imagepicker.allowsEditing = false
            self.imagepicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagepicker.mediaTypes = [(kUTTypeImage as String)]
            //                , (kUTTypeVideo as String) , (kUTTypeMovie as String)]
            self.present(self.imagepicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Can't find photo Library".localize(), message: "This device doesn't have photo Library".localize(), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK".localize(), style:.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkCamerAccess()
    {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                    DispatchQueue.main.async {
                        self.imagepicker.allowsEditing = false
                        self.imagepicker.sourceType = UIImagePickerController.SourceType.camera
                        self.imagepicker.cameraCaptureMode = .photo
                        
                        self.present(self.imagepicker, animated: true, completion: nil)
                    }
                }else{
                    let alert = UIAlertController(title: "Can't find camera".localize(), message: "This device doesn't have camera".localize(), preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok".localize(), style:.default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Camera", message: "Camera access is necessary to capture your Media", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { action in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    func pickFile(){
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF) , String(kUTTypePlainText) , String(kUTTypeSpreadsheet) , String(kUTTypeText) , "com.microsoft.word.doc" ,"com.microsoft.word.docx" , "org.openxmlformats.wordprocessingml.document" ], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
}
extension AttachFileViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let titleLbl = cell?.viewWithTag(1) as? UILabel{
            titleLbl.text = actions[indexPath.row]
        }
        return cell ?? UITableViewCell()
    }
}

extension AttachFileViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            checkCamerAccess()
            break
        case 1:
            checkPhotoLibraryPermission()
            break
        case 2:
            pickFile()
            break
        default:
            break
        }
    }
    
}

extension AttachFileViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            print(imageURL.typeIdentifier ?? "unknown UTI")
            self.dismiss(animated: true) {
                self.uploadUrl(url: imageURL.absoluteString , name: "img\(Date.timeIntervalSinceReferenceDate)")
            }
        }else{
            guard let selectedImage : UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
            }
            self.dismiss(animated: true) {
                self.uploadImage(image: selectedImage)
            }
        }
    }
    
    func getImageString(image : UIImage)->String{
        if image != UIImage(){
            let imageData : NSData = NSData(data: image.jpegData(compressionQuality: 0.5)!)
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            return strBase64
        }else{
            return  ""
        }
    }
    
    func uploadUrl(url : String , name : String = ""){
        let dataSource = AttachmentDataSource()
        showLoader()
        dataSource.uploadAttachment(url: url) { (status, response) in
            self.hideLoader()
            switch status{
            case .sucess:
                let file = response as? AttachedFile ?? AttachedFile()
                self.dismiss(animated: true) {
                    if self.completion != nil {
                        self.completion(file)
                    }
                }
                break
            case .error , .networkError:
                self.showMessage(response as? String ?? "Something went wrong")
                break
            }
        }
    }
    
    func uploadImage(image : UIImage){
           let dataSource = AttachmentDataSource()
           showLoader()
           dataSource.uploadAttachment(image: image) { (status, response) in
               self.hideLoader()
               switch status{
               case .sucess:
                let file = response as? AttachedFile ?? AttachedFile()
                self.dismiss(animated: true) {
                    if self.completion != nil {
                        self.completion(file)
                    }
                }
                   break
               case .error , .networkError:
                self.showMessage(response as? String ?? "Something went wrong")
                   break
               }
           }
       }
}
extension AttachFileViewController : UIDocumentPickerDelegate{
    

    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        
        uploadUrl(url: myURL.absoluteString)
//        + "." + myURL.absoluteString.fileExtension()
    }


    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
         print("import result : \(url)")
         uploadUrl(url: url.absoluteString)
    }



    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
