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
    var statusItemText = ""
    var ethPrice = ""
    var btcPrice = ""
    var xrpPrice = ""

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.title = "0"
        setBitcoinPrice()
        _ = Timer.scheduledTimer(timeInterval: 60.0 * 5,
                                 target: self,
                                 selector: #selector(AppDelegate.setBitcoinPrice),
                                 userInfo: nil,
                                 repeats: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func setBitcoinPrice(){
        self.statusItemText = ""
        Alamofire.request("https://api.bitso.com/v3/ticker/?book=btc_mxn").responseJSON { response in
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                let payload = JSON["payload"] as! NSDictionary
                let amount = payload["last"] as! String
                //self.sendBtcToFirebase(btcPrice: amount)
                self.statusItemText = self.statusItemText + " BTC " + self.formatBitcoinPrice(price: amount)
                print(self.formatBitcoinPrice(price: amount))
                self.statusItem.title = self.statusItemText
            }
        }
        
        Alamofire.request("https://api.bitso.com/v3/ticker/?book=eth_mxn").responseJSON { response in
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                let payload = JSON["payload"] as! NSDictionary
                let amount = payload["last"] as! String
                self.statusItemText = self.statusItemText + " ETH " + self.formatBitcoinPrice(price: amount)
                print(self.formatBitcoinPrice(price: amount))
                self.statusItem.title = self.statusItemText
            }
        }
        
        Alamofire.request("https://api.bitso.com/v3/ticker/?book=xrp_mxn").responseJSON { response in
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                let payload = JSON["payload"] as! NSDictionary
                let amount = payload["last"] as! String
                self.statusItemText = self.statusItemText + " XRP " + self.formatBitcoinPrice(price: amount)
                print(self.formatBitcoinPrice(price: amount))
                self.statusItem.title = self.statusItemText
            }
        }
        
        Alamofire.request("https://api.bitso.com/v3/ticker/?book=ltc_mxn").responseJSON { response in
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                let payload = JSON["payload"] as! NSDictionary
                let amount = payload["last"] as! String
                self.statusItemText = self.statusItemText + " LTC " + self.formatBitcoinPrice(price: amount)
                print(self.formatBitcoinPrice(price: amount))
                self.statusItem.title = self.statusItemText
            }
        }
    }
    
    func formatBitcoinPrice(price: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: Float(price)!))!
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}

