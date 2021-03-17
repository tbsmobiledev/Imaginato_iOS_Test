import UIKit
import Foundation
import SystemConfiguration
import Alamofire
import RxRelay
import RxSwift
import RxCocoa

let api_manager : APIManager = APIManager.sharedIntance
class APIManager: NSObject {
    static let sharedIntance = APIManager()
    
    func callJsonRequest(isLoader: Bool, strURL: String, httpMethod: HTTPMethod, params: [String: AnyHashable]?, isJsonEncoding:Bool, completion :@escaping((_ isSuccess: Bool, _ response: Data?, _ errorMessage: String?, _ statusCode:Int) -> Void)) {
                
        if isLoader { showProgressIn(viewcotroller: topViewController()!) }
        
        let headers = HTTPHeaders.default
        
        var encoding:ParameterEncoding!
        
        if isJsonEncoding{
            encoding = JSONEncoding(options: .prettyPrinted)
        }else{
            let destination:URLEncoding.Destination = (httpMethod == .get) ? URLEncoding.Destination.methodDependent : URLEncoding.Destination.httpBody
            encoding = URLEncoding(destination: destination)
        }
                    
        AF.request(strURL,method: httpMethod,parameters: params,encoding: encoding, headers: headers)
            .responseJSON { (response) in
                if isLoader{hideProgress()}
                if let data = response.data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            apiLog(url: strURL, params: params ?? ["":""], error: "", response: json)
                        }else{
                            apiLog(url: strURL, params: params ?? ["":""], error: "", response: ["API Response":response.result])
                        }
                    }catch {}
                    completion(true, data, nil,response.response?.statusCode ?? 0)
                }
                else {
                    apiLog(url: strURL, params: params ?? ["":""], error: response.error?.localizedDescription ?? kSomethingWentWrong, response: ["":""])
                    completion(false, nil, kSomethingWentWrong,response.response?.statusCode ?? 0)
                }
            }
    }
    
    func uploadImageToServer(isLoader: Bool = true, strURL:String, isDataArray : Bool = false, postdatadictionary: [AnyHashable: Any], httpMethod : HTTPMethod, completion :@escaping((_ isSuccess: Bool, _ response: Data?, _ errorMessage: String?, _ statusCode:Int) -> Void)) {
                
        if isLoader { showProgressIn(viewcotroller: topViewController()!) }
        
//        var headers = HTTPHeaders.default
//        if defaults.value(forKey: kAccessToken) != nil{
//            headers = ["Authorization": "\(defaults.value(forKey: kTokenType) ?? "") \(defaults.value(forKey: kAccessToken) ?? "")"]
//        }
        
//        print("Headers: \(headers)")

        AF.upload(multipartFormData: { (multipartFormData) in
            for (key,value) in postdatadictionary {
                var randomInt = arc4random()

                if value is Data{
                    multipartFormData.append(value as! Data, withName: key as! String, fileName: "\(randomInt).jpg", mimeType: "image/jpeg")
                } else {
                    if let arrData = value as? [Data] {
                        for (index, data) in arrData.enumerated() {
                            randomInt = arc4random()
                            if isDataArray {
                                multipartFormData.append(data, withName: "\(key)[\(index)]", fileName: "\(randomInt).jpeg", mimeType: "image/jpeg")
                            }
                            else {
                                multipartFormData.append(data, withName: key as! String)
                            }
                        }
                    } else {
                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key as! String)
                    }
                }
            }
        }, to: strURL)
            .responseJSON { (response) in
                hideProgress()
                if let dict = response.value as? [String : AnyObject] {
                    do {
                        let json = try JSONSerialization.data(withJSONObject: response.value!, options: .prettyPrinted)
                        apiLog(url: strURL, params: postdatadictionary as! [String : AnyHashable], error: "", response: dict)
                        completion(true, json, nil,response.response!.statusCode)
                    }catch {
                        completion(true, nil, kSomethingWentWrong,response.response?.statusCode ?? 0)
                    }
                } else {
                    apiLog(url: strURL, params: postdatadictionary as! [String : AnyHashable], error: response.error?.localizedDescription ?? kSomethingWentWrong, response: ["":""])
                    completion(false, nil, kSomethingWentWrong,response.response?.statusCode ?? 0)
                }
        }
    }
}


//MARK:- GENERIC API RESPONSE PARSING WITH CODABLE MODEL

open class GenericDecoder<IN, OUT: Codable> {
    public class func decode(_ inObject: IN) -> OUT? {
        fatalError("This method is empty please implement it on a subclass")
    }
}

class GenericJSONDecoder<IN, OUT: Codable> : GenericDecoder<IN, OUT> {
    public override class func decode(_ inObject: IN) -> OUT? {

        do {
            return try JSONDecoder().decode(OUT.self, from: inObject as! Data)
        } catch let error {
            print("JSON parsing error : \(error.localizedDescription)")
            return nil
        }
    }
}


open class APICall<responseModel: Codable> {

    public class func callAPI(isLoader: Bool = true, isMultipart: Bool = false, api: String, isDataArray : Bool = false,  params: [String: AnyHashable]?, methodType: HTTPMethod, isJsonEncoding:Bool = false) -> Observable<responseModel> {
        
        return Observable<responseModel>.create { observer in
            
            if isMultipart {
                api_manager.uploadImageToServer(isLoader: isLoader, strURL: api, isDataArray: isDataArray, postdatadictionary: params ?? ["" : ""], httpMethod: methodType) { (isSuccess, responseData, message,statusCode) in

                    if isSuccess {
                        guard let dataModel = GenericJSONDecoder<Data, responseModel>.decode(responseData!) else {
                            observer.onError(NSError(domain: kSomethingWentWrong, code: statusCode, userInfo: [:]))
                            return
                        }
                        observer.onNext(dataModel)
                    } else {
                        observer.onError(NSError(domain: kSomethingWentWrong, code: statusCode, userInfo: [:]))
                    }
                    observer.onCompleted()
                }
            } else {
                api_manager.callJsonRequest(isLoader: isLoader, strURL: api, httpMethod: methodType, params: params,isJsonEncoding: isJsonEncoding) { (isSuccess, responseData, message,statusCode) in
                    if isSuccess {
                        guard let dataModel = GenericJSONDecoder<Data, responseModel>.decode(responseData!) else {
                            observer.onError(NSError(domain: kSomethingWentWrong, code: statusCode, userInfo: [:]))
                            return
                        }
                        observer.onNext(dataModel)
                    } else {
                        observer.onError(NSError(domain: kSomethingWentWrong, code: statusCode, userInfo: [:]))
                    }
                    observer.onCompleted()
                }
            }
            
            return Disposables.create {
            }
        }
    }
}
