//
//  ViewController.swift
//  TryLibrary
//
//  Created by Rosario Galioto on 20/08/22.
//

import UIKit
import RealityKit
import PositioningLibrary
import MapKit
import Drops // to show messages

class ViewController: UIViewController, LocationObserver {
    
    @IBOutlet var debugLabel: UILabel!
    @IBOutlet var arView: ARView!
    private var locationProvider: LocationProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dynamic creation
//        let myMarkers = loadDynamicData()
//        self.locationProvider = LocationProvider(arView: arView, markers: myMarkers)
        
        // static creation (from JSON)
        self.locationProvider = LocationProvider(arView: arView, jsonName: "mydata")
        
        self.locationProvider.addLocationObserver(locationObserver: self)
        self.locationProvider.start(debug: true)
        
        // creation of FloorMapView w/ the Outlet
//        arView.addSubview(floorMapView)
//        self.locationProvider.addLocationObserver(locationObserver: floorMapView)
        
        // creation of FloorMapView w/ the library (SUGGESTED)
        self.locationProvider.showFloorMap(CGRect(x: 20, y: 40, width: 247, height: 323))
    }
    
    func loadDynamicData() -> [Marker] {
        let b1 = Building(id: "b1", name: "Casa", coord: CLLocationCoordinate2D(latitude: 45.47908247767321, longitude: 9.227200675127934))
        let floor0 = Floor(id: "f1_1", name: "piano terra", number: 0, building: b1, maxWidth: 8.16, maxHeight: 5.3, floorMap: UIImage(named: "piano0")!)
        let floor1 = Floor(id: "f1_2", name: "primo piano", number: 1, building: b1, maxWidth: 6.55, maxHeight: 13.65, floorMap: UIImage(named: "piano1")!)
        
        // floor0 markers
        let l1_c = Location(coordinates: CGPoint(x: 0, y: 0.90), heading: -1.57, floor: floor0)
        
        let l1_r = Location(coordinates: CGPoint(x: 0.90, y: 5.50), heading: 3.14, floor: floor0)
        let l2_r = Location(coordinates: CGPoint(x: 2.97, y: 3.20), heading: 1.57, floor: floor0)
        
        let l1_s = Location(coordinates: CGPoint(x: 5.15, y: 3.1), heading: 0, floor: floor0)
        let l2_s = Location(coordinates: CGPoint(x: 8.10, y: 3.95), heading: 1.57, floor: floor0)
        
        let l1_b = Location(coordinates: CGPoint(x: 6.6, y: 2.70), heading: 3.14, floor: floor0)
        let l2_b = Location(coordinates: CGPoint(x: 8.1, y: 1.18), heading: 1.57, floor: floor0)
        
        let m1_c = Marker(id: "CO1", image: UIImage(named: "co1")!, physicalWidth: 0.12, location: l1_c)
        
        let m1_r = Marker(id: "CR1", image: UIImage(named: "cr1")!, physicalWidth: 0.28, location: l1_r)
        let m2_r = Marker(id: "CR2", image: UIImage(named: "cr2")!, physicalWidth: 0.28, location: l2_r)
        
        let m1_s = Marker(id: "CS1", image: UIImage(named: "cs1")!, physicalWidth: 0.12, location: l1_s)
        let m2_s = Marker(id: "CS2", image: UIImage(named: "cs2")!, physicalWidth: 0.22, location: l2_s)

        let m1_b = Marker(id: "BG1", image: UIImage(named: "bg1")!, physicalWidth: 0.12, location: l1_b)
        let m2_b = Marker(id: "BG2", image: UIImage(named: "bg2")!, physicalWidth: 0.12, location: l2_b)
        
        // floor1 markers
        let l1_sl = Location(coordinates: CGPoint(x: 6.5, y: 9.5), heading: 1.57, floor: floor1)
        let l2_sl = Location(coordinates: CGPoint(x: 1.9, y: 4.70), heading: 0, floor: floor1)
        
        let l1_st = Location(coordinates: CGPoint(x: 0, y: 2.60), heading: -1.57, floor: floor1)
        let l2_st = Location(coordinates: CGPoint(x: 3.80, y: 1.25), heading: 1.57, floor: floor1)

        let m1_sl = Marker(id: "SL1", image: UIImage(named: "sl1")!, physicalWidth: 1, location: l1_sl)
        let m2_sl = Marker(id: "Sl2", image: UIImage(named: "sl2")!, physicalWidth: 1, location: l2_sl)
        
        let m1_st = Marker(id: "ST1", image: UIImage(named: "st1")!, physicalWidth: 0.15, location: l1_st)
        let m2_st = Marker(id: "ST2", image: UIImage(named: "st2")!, physicalWidth: 0.48, location: l2_st)

        return [m1_c, m1_r, m2_r, m1_s, m2_s, m1_b, m2_b, m1_sl, m2_sl, m1_st, m2_st]
    }
    
    func onLocationUpdate(_ newLocation: ApproxLocation) {
//        print("New Location Update: \(newLocation)")
        debugLabel.text = "X: \(String(format:"%.2f",newLocation.coordinates.x))  Y: \(String(format:"%.2f",newLocation.coordinates.y))  Heading: \(String(format:"%.2f",newLocation.heading))"
    }
    
    func onBuildingChanged(_ newBuilding: Building) {
        print("Building changed: \(newBuilding.name)")
        let drop = Drop(
            title: newBuilding.name,
            subtitle: "Building changed",
            icon: UIImage(systemName: "building"),
            accessibility: "Alert: Title, Subtitle"
        )
        Drops.show(drop)
    }
    
    func onFloorChanged(_ newFloor: Floor) {
        print("Floor changed: \(newFloor.number)")
        let drop = Drop(
            title: newFloor.name,
            subtitle: "Floor changed: \(newFloor.number)°",
            icon: UIImage(systemName: "chevron.up.chevron.down"),
            accessibility: "Alert: Title, Subtitle"
        )
        Drops.show(drop)
    }
    

    @IBAction func btnCenterTouched(_ sender: Any) {
        self.locationProvider.centerToUserPosition()
    }
}
