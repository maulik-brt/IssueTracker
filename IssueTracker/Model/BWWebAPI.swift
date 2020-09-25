//
//  BWWebAPI.swift
//  IssueReport
//
//  Created by Bluewhale-iOS-Team on 18/09/20.
//

import Foundation
import Alamofire
import Toast_Swift

class BWWebAPI {
    
    static let sharedService = BWWebAPI()
    
    // MARK: - UnAuthed API
    
    func uploadMedia(_ Dict: [String: AnyObject],onSuccess: @escaping (AnyObject) -> (), onFailure: @escaping (Error) -> ())-> Void {
        let isVideo = Dict["isVideo"] as! Bool
        var data = Data()
        var strurl = String()
        if isVideo == true{
            strurl = WebServiceCall.KbaseURL + ApiMethodName.kUpload + ApiMethodName.kVideoname
            let videoURL = Dict["videoURL"]
            if let videoData = NSData(contentsOf: videoURL as! URL) {
                data = videoData as Data
            }
            
        }else{
            strurl = WebServiceCall.KbaseURL + ApiMethodName.kUpload + ApiMethodName.kImagename
            let image = Dict["image"] as! UIImage
            guard let imageData = image.jpegData(compressionQuality: 0.4) else {
                return
            }
            data = imageData
        }
        
        
        let headers : HTTPHeaders = [
            WebServiceCall.KContentType: WebServiceCall.KContentValueoctet,
            WebServiceCall.kAuthorization: WebServiceCall.KAuthorizationToken
        ]
        
        
        AF.upload(data as Data, to: URL(string: strurl)!, method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let upload):
                if let result = upload as? Dictionary<String, AnyObject> {
                    if let dict1 = result["upload"]  as? Dictionary<String, AnyObject>{
                        if let token = dict1["token"] as? String{
                            self.createIssue(Dict, token: token) { (response) in
                                onSuccess (response as AnyObject)
                            } onFailure: { (error) in
                                onFailure(error)
                            }
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                onFailure(encodingError)
            }
        }
    }
    
    func createIssue(_ Dict: [String: AnyObject], token: String, onSuccess: @escaping (AnyObject) -> (), onFailure: @escaping (Error) -> ())-> Void {
        let isVideo = Dict["isVideo"] as! Bool
        
        let strurl = WebServiceCall.KbaseURL + ApiMethodName.kIssue
        var dictUpload = [String : String]()
        let headers : HTTPHeaders = [
            WebServiceCall.KContentType: WebServiceCall.KContentValuejson,
            WebServiceCall.kAuthorization: WebServiceCall.KAuthorizationToken
        ]
        
        let sub = Dict["subject"] as! String
        let project_id = Dict["project_id"] as! String
        let description = Dict["description"] as! String
        let Build_Number = Dict["Build_Number"] as! String
        let Device_Info = Dict["Device_Info"] as! String
        let ReportedBy = Dict["ReportedBy"] as! String
        let Connectiontype = Dict["Connectiontype"] as! String
        let Environment = Dict["Environment"] as! String
        let TimeZone = Dict["TimeZone"] as! String
        let Fixed_version_id = Dict["Fixed_version_id"] as! String

        
        let Desc = "\(description)\n\n Build Number: \(Build_Number)\nDevice Info: \(Device_Info)\nReported By: \(ReportedBy)\nConnection type: \(Connectiontype)\nEnvironment: \(Environment)\nTimeZone: \(TimeZone)"
        let strSub = "iOS - \(sub)"
        
        if isVideo == true{
            dictUpload = [
                "token" : token,
                "filename": "attachment.mp4",
                "content_type": "video/mp4"
            ]
        }else{
            dictUpload = [
                "token" : token,
                "filename": "attachment.jpg",
                "content_type": "image/jpg"
            ]
        }
        
        let arrUpload : NSArray = NSArray(object: dictUpload)
        
        let params : NSDictionary = ["issue" : [
            "project_id" : project_id,
            "subject" : strSub,
            "description": Desc,
            "fixed_version_id":Fixed_version_id,
            "uploads" : arrUpload
        ]]
        
        print(params)
        
        AF.request(URL.init(string: strurl)!, method: .post, parameters: params as? Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            switch response.result {
            case .success(let upload):
                if let result = upload as? Dictionary<String, AnyObject> {
                    onSuccess (result as AnyObject)
                }
                break
            case .failure(let error):
                onFailure(error)
                break
            }
        }
    }
    
}
