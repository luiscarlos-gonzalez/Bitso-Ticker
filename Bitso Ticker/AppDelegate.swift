//
//  AppDelegate.swift
//  Bitso Ticker
//
//  Created by Luis Carlos  on 05/04/17.
//  Copyright © 2017 Kentverger. All rights reserved.
//

import Cocoa
import Alamofire
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: -1)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.title = "0"
        setBitcoinPrice()
        _ = Timer.scheduledTimer(timeInterval: 60.0 * 10,
                                 target: self,
                                 selector: #selector(AppDelegate.setBitcoinPrice),
                                 userInfo: nil,
                                 repeats: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func setBitcoinPrice(){
        Alamofire.request("https://api.bitso.com/v3/ticker/?book=btc_mxn").responseJSON { response in
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                let payload = JSON["payload"] as! NSDictionary
                let amount = payload["ask"] as! String
                self.statusItem.title = self.formatBitcoinPrice(price: amount)
                print(self.formatBitcoinPrice(price: amount))
            }
        }
    }
    
    func formatBitcoinPrice(price: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: Float(price)!))!
    }


}

