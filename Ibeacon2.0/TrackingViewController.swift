//
//  TrackViewController.swift
//  IBeacon
//
//  Created by MR932 on 24/07/2021.
//

import UIKit
import CoreLocation

class TrackingViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var beaconFoundLable: UILabel!
    @IBOutlet var proximityUUIDLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var minorLabel: UILabel!
    @IBOutlet var accuracyLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var rssiLabel: UILabel!
    @IBOutlet var rangeLable: UILabel!
    
    var locationManager : CLLocationManager!
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")
    // Note: make sure you replace the keys here with your own beacons' Minor Values
    let colors = [
        13840: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        44231: UIColor(red: 98/255, green: 255/255, blue: 185/255, alpha: 1),
        39626: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        locationManager.requestWhenInUseAuthorization()
        startScanningForBeaconRegion(beaconRegion: getBeaconRegion())
    }
    
    func getBeaconRegion() -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion.init(proximityUUID: UUID.init(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
                                               identifier: "")
        return beaconRegion
    }
    
    func calculateNewDistance(txCalibratedPower: Int, rssi: Int) -> Double {
        if rssi == 0 {
            return -1
        }
        let ratio = Double(exactly:rssi)!/Double(txCalibratedPower)
        if ratio < 1.0{ return pow(10.0, ratio)
            
        } else {
            let accuracy = 0.89976 * pow(ratio, 7.7095) + 0.111
            return accuracy
        }
        
        
    }

    
    func startScanningForBeaconRegion(beaconRegion: CLBeaconRegion) {
        print(beaconRegion)
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    // Delegate Methods
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let beacon = beacons.last
        //
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            self.view.backgroundColor = self.colors[closestBeacon.minor.intValue]
            if beacons.count > 0 {
                beaconFoundLable.text = "Yes"
                proximityUUIDLabel.text = beacon?.proximityUUID.uuidString
                majorLabel.text = beacon?.major.stringValue
                minorLabel.text = beacon?.minor.stringValue
                if beacon?.proximity == CLProximity.unknown {
                    distanceLabel.text = "Unknown Proximity"
                } else if beacon?.proximity == CLProximity.immediate {
                    distanceLabel.text = "Immediate Proximity"
                    //self.view.backgroundColor = .orange
                } else if beacon?.proximity == CLProximity.near {
                    distanceLabel.text = "Near Proximity"
                    //self.view.backgroundColor = .blue
                } else if beacon?.proximity == CLProximity.far {
                    distanceLabel.text = "Far Proximity"
                    //self.view.backgroundColor = .green
                }
                accuracyLabel.text = String(describing: beacon?.accuracy)
                rssiLabel.text = String(describing: beacon?.rssi)
            } else {
                beaconFoundLable.text = "No"
                proximityUUIDLabel.text = ""
                majorLabel.text = ""
                minorLabel.text = ""
                distanceLabel.text = ""
                rssiLabel.text = ""
            }
        }
        //
        
        
        print("Ranging")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


