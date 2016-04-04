//
//  LocationManager.swift
//  ExisChatSwift
//
//  Created by Chase Roossin on 4/5/16.
//  Copyright © 2016 Exis. All rights reserved.
//

import UIKit
import CoreLocation

//possible errors
enum OneShotLocationManagerErrors: Int {
    case AuthorizationDenied
    case AuthorizationNotDetermined
    case InvalidLocation
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    //location manager
    private var locationManager: CLLocationManager?

    //destroy the manager
    deinit {
        locationManager?.delegate = nil
        locationManager = nil
    }

    typealias LocationClosure = ((location: CLLocation?, error: NSError?)->())
    private var didComplete: LocationClosure?

    //location manager returned, call didcomplete closure
    private func _didComplete(location: CLLocation?, error: NSError?) {
        locationManager?.stopUpdatingLocation()
        didComplete?(location: location, error: error)
        locationManager?.delegate = nil
        locationManager = nil
    }

    //location authorization status changed
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {
        case .AuthorizedWhenInUse:
            self.locationManager!.startUpdatingLocation()
        case .Denied:
            _didComplete(nil, error: NSError(domain: self.classForCoder.description(),
                code: OneShotLocationManagerErrors.AuthorizationDenied.rawValue,
                userInfo: nil))
        default:
            break
        }
    }

    internal func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        _didComplete(nil, error: error)
    }

    internal func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        _didComplete(location, error: nil)
    }

    //ask for location permissions, fetch 1 location, and return
    func fetchWithCompletion(completion: LocationClosure) {
        //store the completion closure
        didComplete = completion

        //fire the location manager
        locationManager = CLLocationManager()
        locationManager!.delegate = self

        //check for description key and ask permissions
        if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil) {
            locationManager!.requestWhenInUseAuthorization()
        } else if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil) {
            locationManager!.requestAlwaysAuthorization()
        } else {
            fatalError("To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
        }

    }

    func findUserCity(userLocation: CLLocation, completion: (currCity: String?) -> Void) {
        let geoCoder = CLGeocoder()
        let location = userLocation

        geoCoder.reverseGeocodeLocation(location){(placemarks, error) -> Void in
            let placeArray = placemarks as [CLPlacemark]!

            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]

            //City
            let city = placeMark.addressDictionary?["City"] as? String

            //State
            let state = placeMark.addressDictionary?["State"] as? String

            completion(currCity: city! + ", " + state!)
        }
    }
}
