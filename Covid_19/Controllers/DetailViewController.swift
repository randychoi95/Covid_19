//
//  DetailViewController.swift
//  Covid_19
//
//  Created by 최제환 on 2021/08/13.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var facilityName_label: UILabel!
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var phoneNum_button: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Property
    var facility_Info: Centers.Center?
    
    // MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFacilityInfo()
        setMapView()
    }
    
    // MARK: IBAction
    @IBAction func phoneCallAction(_ sender: Any) {
        if let phoneNum = self.facility_Info?.phoneNumber {
            if let phoneCallURL = URL(string: "tel://\("\(phoneNum)")") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    // MARK: Custom Function
    private func setFacilityInfo() {
        if let name = self.facility_Info?.facilityName {
            self.facilityName_label.text = name
            self.navigationItem.title = name
        }
        if let address = self.facility_Info?.address {
            self.address_label.text = address
        }
        if let phone = self.facility_Info?.phoneNumber {
            self.phoneNum_button.setTitle(phone, for: .normal)
        }
    }
    
    private func setMapView() {
        if let lat = self.facility_Info?.lat, let lng = self.facility_Info?.lng, let latitude = Double(lat), let longitude = Double(lng) {
            
            // 위도와 경도를 가지고 2D(한 점) 정보
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // 한 점에서부터 거리(m)를 반영하여 맵의 크기
            // 1km로 설정
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
            // 위치 표시하기
            let annotaion = MKPointAnnotation()
            annotaion.coordinate = location
            annotaion.title = self.facilityName_label.text
            annotaion.subtitle = self.address_label.text
            
            // mapView에 적용
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(annotaion)
        }
    }
}
