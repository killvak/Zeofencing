# Zeofencing
First Thing setup user location and show it on Map after import the frameWork to your ViewController that :-

 set Annotations value ex :
 
     let data2 = ["AppsSquare" : (30.794940197245495, 30.996800645431936), "My Cafe" : (37.703026, -121.759735), "My Cafe2" : (37.702976, -121.760731), "My Cafe3" : (37.702894, -121.761717), "My Cafe4" : (37.702799, -121.762568), "My Cafe5" : (37.702606, -121.763943)]
     
      class GetData  {    
      func xyz(data : Dictionary<String,(Double,Double)>) -> [Annotations]{
        var arr = [Annotations]()
        for z in data {
            let y = Annotations(coordinate: CLLocationCoordinate2D( latitude: z.value.0,  longitude: z.value.1), radius: 100, identifier: NSUUID().uuidString, note: z.key, eventType: EventType.onEntry   )
            arr.append(y)
        }
        return arr
     }
   ok, Let's start 
     
        import Zeofencing 
apply the  ZeofencingProtocol 
  ex : 
      
      class ViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate , ZeofencingProtocol { }
        
  - define an array of Annotations and declare SetupAnnotationClass 
      ex :    
      
        var geotifications : [Annotations] = []
        let setupAnnotation = SetUpAnnotations()
        
  - P.S : don't forget to make the map follow and track the user location:
  
                mapView.userTrackingMode = MKUserTrackingMode.follow
                
  -    To set new Annotations to the map use the below function it take the  annotations array , the mapView and the locationManager. 
  ex : 
  
        setupAnnotation.setupAnnotationDataOnMap( anotationsArray: geotifications, mapView: mapView ,locationManager : locationManager)

*Apply to the ZeofencingProtocol  :
   
   
    ///just insert the mapView func parameters to setupAnnotations.mapView func
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return  setupAnnotation.mapView(mapView, viewFor: annotation)
    }
        ///just insert the mapView func parameters to setupAnnotations.mapView func   & 
        you have to set the circleStrokeColor and circleLineWidth , circlefillColor and it's alpha is an optional u can set it to nil if u don't want to use it 
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

//declare locationManager Constant in the AppDelegateClass

     let  locationManager = CLLocationManager()

//Replace your didFinishLaunchingWithOptions  with this to use local Notifications 


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        locationManager.delegate = self
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        UIApplication.shared.cancelAllLocalNotifications()
        return true
    }
    
    
 //declare this function  in the AppDelegateClass
 
 
     func handleEvent(forRegion region: CLRegion!, state : String) {
        // Show an alert if application is active
        guard let message = SetUpAnnotations.note(fromRegionIdentifier: region.identifier) else { return }
        if UIApplication.shared.applicationState == .active {
            window?.rootViewController?.showAlert(withTitle: nil, message: state + message)
        } else {
            // Otherwise present a local notification
            let notification = UILocalNotification()
            notification.alertBody = state + message
            notification.soundName = "Default"
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
          }

add this extension to your project :-
    
    
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
