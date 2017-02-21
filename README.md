# Zeofencing
First Thing setup user location and show it on Map after import the frameWork to your ViewController that :-

    import Zeofencing 
apply the  ZeofencingProtocol 
  ex : 
      
      class ViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate , ZeofencingProtocol { }
        
  - define an array of Geotification which is the Map Annotations and declare SetupAnnotationClass 
      ex :    
      
        var geotifications : [Geotification] = []
        let setupAnnotation = SetUpAnnotations()
        
  - P.S : don't forget to make the map follow and track the user location:
  
                mapView.userTrackingMode = MKUserTrackingMode.follow
                
  -    To set new Annotations to the map use the below function it take the  annotations array (geotifications) and the mapView and the locationManager. 
  ex : 
  
        setupAnnotation.setupAnnotationDataOnMap( anotationsArray: geotifications, mapView: mapView ,locationManager : locationManager)

*Apply to the ZeofencingProtocol  :
   
   
    ///just insert the mapView func parameters to setupAnnotations.mapView func
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return  setupAnnotation.mapView(mapView, viewFor: annotation)
    }
        ///just insert the mapView func parameters to setupAnnotations.mapView func        
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return setupAnnotation.mapView(mapView, rendererFor: overlay, circleStrokeColor: UIColor.purple, circleLineWidth: 1.0, fillColor: nil, fillColorWithAlphaComponent: nil)
    }
        ///Handel the error if occurred is preferred   
      func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(error.localizedDescription)")
        for monitoredRegion in manager.monitoredRegions {
            print("Monitored Region are : \(monitoredRegion)")
        }
    }
        ///Handel the error if occurred is preferred         
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    
/////////////////////
AppDelegateClass , Local Notification Setup :

//declare locationManager Constant

     let  locationManager = CLLocationManager()

//Replace your didFinishLaunchingWithOptions  with this to use local Notifications 


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        locationManager.delegate = self
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        UIApplication.shared.cancelAllLocalNotifications()
        return true
    }
    
    
 //declare this function 
 
 
     func handleEvent(forRegion region: CLRegion!, state : String) {
        // Show an alert if application is active
        if UIApplication.shared.applicationState == .active {
            guard let message = SetUpAnnotations.note(fromRegionIdentifier: region.identifier) else { return }
            window?.rootViewController?.showAlert(withTitle: nil, message: state + message)
        } else {
            // Otherwise present a local notification
            guard let message = SetUpAnnotations.note(fromRegionIdentifier: region.identifier) else { return }
            let notification = UILocalNotification()
            notification.alertBody = state + message
            notification.soundName = "Default"
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
          }
    
    * add this extension  :-
    
    
    extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region,state:"welcome in ")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region,state:"see you soon, Best Regards ")
        }
    }}
