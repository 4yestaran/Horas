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

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?

    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager=CLLocationManager()
        locationManager?.delegate=self
        //locationManager.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
    }


    @IBAction func sendNotification(_ sender: UIButton) {
        let content = UNMutableNotificationContent()
        content.title = "Horas Demo"
        content.subtitle = "Probando localización"
        content.body = "Has entrado o salido de Paradigma"
        content.categoryIdentifier = "message"
        
        let latitude = UserDefaults.standard.double(forKey: "location_latitude")
        let longitude = UserDefaults.standard.double(forKey: "location_longitude")
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //let center = CLLocationCoordinate2D(latitude: 40.440342, longitude: -3.787071)
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
    
    func getTimeAsText() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let hora = formatter.string(from: now)
        print (hora)
        return hora
    }
    
    @IBAction func startRecord(_ sender: Any) {
        startTime.text = getTimeAsText()
    }
    
    @IBAction func endRecord(_ sender: Any) {
        endTime.text = getTimeAsText()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            //let center = CLLocationCoordinate2D(latitude: 40.440342, longitude: -3.787071)
            let latitude = UserDefaults.standard.double(forKey: "location_latitude")
            let longitude = UserDefaults.standard.double(forKey: "location_longitude")
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = CLCircularRegion(center: center, radius: 500.0, identifier: "Headquarters")
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
            latitudeLabel.text=latitude.description
            longitudeLabel.text=longitude.description
            
            locationManager?.startMonitoring(for: region)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NSLog("Entering region")
        let entryTime = getTimeAsText()
        startTime.text = entryTime
     
        if UIApplication.shared.applicationState == .active {
            showAlert(entryTime: entryTime)
        } else {
            let content = UNMutableNotificationContent()
            content.title = "Horas Demo"
            //content.subtitle = "Probando localización"
            content.body = "Hora de entrada \(entryTime)"
            content.categoryIdentifier = "message"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "horas.paradigma",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        NSLog("Exiting region")
        let entryTime = getTimeAsText()
        endTime.text = entryTime
        
        if UIApplication.shared.applicationState == .active {
            showAlert(entryTime: entryTime)
        } else {
            let content = UNMutableNotificationContent()
            content.title = "Horas Demo"
            //content.subtitle = "Probando localización"
            content.body = "Hora de salida \(entryTime)"
            content.categoryIdentifier = "message"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "horas.paradigma",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    func showAlert(entryTime: String) {
        let alert = UIAlertController(title: "Horas", message: "Hora: \(entryTime)", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
}

