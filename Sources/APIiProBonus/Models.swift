//
//  File.swift
//  
//
//  Created by Alina on 20/5/21.
//

import Foundation

public struct GeneralInfo:Codable {
    
    public init() {
        self.resultOperation = Result(status: 0, idLog: "", message: nil)
        self.data = nil
    }
    
    public var resultOperation:Result
    public var data:Info?
}


extension GeneralInfo{
    public var ShowingView:Bool{
        get{
           data != nil
        }
    }
    public var ShowingAlert:Bool{
        get {
            resultOperation.message != nil
        }
        set {
            resultOperation.message = nil
        }
    }
}

public struct Info: Codable {
    public var typeBonusName:String
    public var currentQuantity:Int
    public var forBurningQuantity:Int
    public var dateBurning:String
}


struct AccessTokenRequest:Codable {
    var idClient:String
    var accessToken:String = ""
    var paramName:String = "device"
    var paramValue:String
    var latitude:Int = 0
    var longitude:Int = 0
    var sourceQuery:Int = 0
    
    init(ClientID:String, DeviceID:String) {
        idClient = ClientID
        paramValue = DeviceID
    }
}

struct AccessToken:Codable {
    let result:Result
    let accessToken:String?
}

public struct Result:Codable {
    public init(status: Int, idLog: String, message: String? = nil) {
        self.status = status
        self.idLog = idLog
        self.message = message
    }
    var status:Int
    var idLog:String
    public var message:String?
}
