//
//  BWWebAPI.swift
//  IssueReport
//
//  Created by Bluewhale-iOS-Team on 18/09/20.
//

import Foundation
import Toast_Swift
import SVProgressHUD

class BWWebAPI {
    
    static let sharedService = BWWebAPI()
    
    
    func uploadMediaNew(_ Dict: [String: AnyObject],onSuccess: @escaping (AnyObject) -> (), onFailure: @escaping (Error) -> ())-> Void {
        
        SVProgressHUD.show(withStatus: "Sending...")

        let isVideo = Dict["isVideo"] as! Bool
        var data = Data()
        var strurl = ""
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
        
        
        let semaphore = DispatchSemaphore (value: 0)
        
        let postData = data
        
        var request = URLRequest(url: URL(string: strurl)!,timeoutInterval: Double.infinity)
        
        request.setValue(WebServiceCall.KContentValueoctet, forHTTPHeaderField: WebServiceCall.KContentType)
        request.setValue(WebServiceCall.KAuthorizationToken, forHTTPHeaderField: WebServiceCall.kAuthorization)

        
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let datass = data else {
            print(String(describing: error))
            return
          }
          print(String(data: datass, encoding: .utf8)!)
          semaphore.signal()
            
            if let dataNew = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: dataNew, options: [])
                    
                    let json = result as! NSDictionary
                    if let dict1 = json["upload"]  as? Dictionary<String, AnyObject>{
                        if let token = dict1["token"] as? String{
                            self.createIssueNew(Dict, token: token) { (response) in
                                onSuccess (response as AnyObject)
                            } onFailure: { (error) in
                                onFailure(error)
                            }
                        }
                    }
                    
                } catch {
                    onFailure(error)
                }
            }
            
            
        }

        task.resume()
        semaphore.wait()
        
    }
    

    func createIssueNew(_ Dict: [String: AnyObject], token: String, onSuccess: @escaping (AnyObject) -> (), onFailure: @escaping (Error) -> ())-> Void {
        
        SVProgressHUD.show(withStatus: "Sending...")

        var dictUpload = [String : String]()
        let isVideo = Dict["isVideo"] as! Bool

        let Url = WebServiceCall.KbaseURL + ApiMethodName.kIssue

        guard let serviceUrl = URL(string: Url) else { return }
        
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
        
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue(WebServiceCall.KContentValuejson, forHTTPHeaderField: WebServiceCall.KContentType)
        request.setValue(WebServiceCall.KAuthorizationToken, forHTTPHeaderField: WebServiceCall.kAuthorization)

        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print(json)
                            onSuccess (json as AnyObject)
                        } catch {
                            onFailure(error)
                        }
                    }
                } else {
                    if let err = error {
                        onFailure(err)
                    }
                }
            } else {
                if let err = error {
                    onFailure(err)
                }
            }
            
            
        }.resume()
    
    }
    
}
