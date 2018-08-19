//
//  AlamofireConnectionMangager.swift
//  MoneyTapTest
//
//  Created by Uniqolabel Developer on 19/08/18.
//  Copyright © 2018 GeekGuns. All rights reserved.
//


import Foundation
import Alamofire

class AlamofireConnectionMangager {
    private static var _instance: AlamofireConnectionMangager?;
    
    private init() {
        
    }
    
    public static func getSingleton() -> AlamofireConnectionMangager {
        if (AlamofireConnectionMangager._instance == nil) {
            AlamofireConnectionMangager._instance = AlamofireConnectionMangager.init();
        }
        return AlamofireConnectionMangager._instance!;
    }
    
    func getDataFromServer( url: String , param : NSDictionary, success: @escaping (NSDictionary) -> () , failure: @escaping (Error?) -> () ) {
        
        
        Alamofire.request(url , method: .get, parameters: param as? [String: Any] , encoding: URLEncoding.default, headers: nil).responseJSON
            {
                (response:DataResponse<Any>) in
                
                print("response.request :", response.request as Any)
                print("response.response :", response.response as Any)
                print("response.result:", response.result as Any)
                print("response.value: ", response.value as Any)
                print("response.error:", response.error as Any)
                
                
                
                if (response.error != nil) {
                    failure(response.error);
                }
                    
                else if (response.value != nil) {
                    success(response.value as! NSDictionary)
                }
                
        }
        
    }
    
}


// This is Use Description
/*
 
 AlamofireConnectionMangager.sharedInstance.getDataFromServer( url: urlSting , param : params as NSDictionary, success: {(responseResult) -> Void in
 
 print("responseResult :::",responseResult)
 print("Success")
 
 }, failure:{(error) -> Void in
 
 if error {
 print("Somting went wrong")
 }
 self.showAlert(alertMessage: "Somthing went wrong")
 
 }) */

