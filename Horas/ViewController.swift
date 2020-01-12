//
//  ViewController.swift
//  Horas
//
//  Created by Vicente Ayestarán on 13/11/2019.
//  Copyright © 2019 Vicente Ayestarán. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func sendNotification(_ sender: UIButton) {
        let content = UNMutableNotificationContent()
        content.title = "Horas Demo"
        content.subtitle = "Probando localización"
        content.body = "Has entrado o salido de Paradigma"
        content.categoryIdentifier = "message"
        
        let latitude = UserDefaults.standard.double(forKey: "location_latitude")
        let longitude = UserDefaults.standard.double(forKey: "location_longitude")
        //let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let center = CLLocationCoordinate2D(latitude: 40.440342, longitude: -3.787071)
        let region = CLCircularRegion(center: center, radius: 500.0, identifier: "Headquarters")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        //let trigger = UNTimeIntervalNotificationTrigger(
        //timeInterval: 10.0,
        //repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "horas.paradigma",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
    }
    
    func composeMessage() {
        
    }
}

