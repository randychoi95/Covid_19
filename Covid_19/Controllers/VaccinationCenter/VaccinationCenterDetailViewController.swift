//
//  DetailViewController.swift
//  Covid_19
//
//  Created by 최제환 on 2021/08/13.
//

import UIKit
import MapKit

class VaccinationCenterDetailViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var facilityName_label: UILabel!
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var phoneNum_button: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Property
    var facility_Info: Center?
    
    var viewModel: VaccinationCenterDetailViewModel!
    
    // MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = VaccinationCenterDetailViewModel(facility_Info: self.facility_Info)
        
        setNavigationItem()
        setFacilityInfo()
        setMapView()
    }
    
    // MARK: IBAction
    @IBAction func phoneCallAction(_ sender: Any) {
        print(viewModel.phoneNum)
        if let phoneCallURL = URL(string: "tel://\("\(viewModel.phoneNum)")") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func copyAddress(_ sender: Any) {
        UIPasteboard.general.string = self.address_label.text
    }
    
    // MARK: Custom Function
    
    // 네비게이션 아이템 세팅
    private func setNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(backButton)
                                                                )
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // 예방접종센터 데이터 세팅
    private func setFacilityInfo() {
        self.facilityName_label.text = viewModel.name
        self.navigationItem.title = viewModel.name
        self.address_label.text = viewModel.address
        self.zipcodeLabel.text = viewModel.zipcode
        self.phoneNum_button.setTitle(viewModel.phoneNum, for: .normal)
    }
    
    // 맵뷰 세팅
    private func setMapView() {
        let lat = viewModel.lat
        let lng = viewModel.lng
        
        if let latitude = Double(lat), let longitude = Double(lng) {
            
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
    
    // 네비게이션 백 버튼 액션함수
    @objc func backButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
