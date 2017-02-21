//
//  Extensions.swift
//  GeoFence FrameWorkﬁ
//
//  Created by Killvak on 16/02/2017.
//  Copyright © 2017 Killvak. All rights reserved.
//


import Foundation
import  MapKit

public struct PreferencesKeys {
    static let savedItems = "savedItems"
}


// MARK: Helper Extensions
extension UIViewController {
   public func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//extension locationManagerProtocol {
//
//   public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        return  setupAnnotation.mapView(mapView, viewFor: annotation)
//    }
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        return setupAnnotation.mapView(mapView, rendererFor: overlay)
//    }
//}
