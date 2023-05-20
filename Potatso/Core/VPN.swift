//
//  ProxyService.swift
//  Potatso
//
//  Created by LEI on 12/28/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import Foundation
import Async
import PotatsoModel
import Appirater
import PotatsoLibrary

class VPN {
    
    static func switchVPN(_ group: ConfigurationGroup, completion: ((Error?) -> Void)? = nil) {
        let defaultUUID = Manager.shared.defaultConfigGroup.uuid
        let isDefault = defaultUUID == group.uuid
        print("[What's Wrong With You]", "VPN switchVPN start to run ", "defaultUUID is ", defaultUUID, "groud.uuid is ", group.uuid)
        if !isDefault {
            Manager.shared.stopVPN()
            print("[What's Wrong With You]", "stopVPN() is invoked in VPN switchVPN")
            Async.main(after: 1) {
                _switchDefaultVPN(group, completion: completion)
            }
        }else {
            _switchDefaultVPN(group, completion: completion)
        }
    }

    fileprivate static func _switchDefaultVPN(_ group: ConfigurationGroup, completion: ((Error?) -> Void)? = nil) {
        Manager.shared.setDefaultConfigGroup(group.uuid, name: group.name)
        print("[What's Wrong With You]", "VPN _switchDefaultVPN start to run and setDefaultConfigGroup over", "group.uuid:", group.uuid, "group.name:", group.name)
        Manager.shared.switchVPN { (manager, error) in
            print("[What's Wrong With You]", "completion for Manager switchVPN start", "error:\(error)")
            if let _ = manager {
                Async.background(after: 2, { () -> Void in
                    Appirater.userDidSignificantEvent(false)
                })
            }
            Async.main{
                completion?(error)
            }
        }
    }
    
}
