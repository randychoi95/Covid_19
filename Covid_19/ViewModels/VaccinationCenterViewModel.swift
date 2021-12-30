//
//  VaccinationCenterViewModel.swift
//  Covid_19
//
//  Created by 최제환 on 2021/12/30.
//

import Foundation
import UIKit

class VaccinationCenterViewModel {
    
    let currentVC: UIViewController
    
    // sevice 키
    let serviceKey  = "9PAc6aMn2DC3xdA7rYZn71Hxr3mT9V5E4qnnakQkwj44zVNrPfV%2FVLVnDsnf30wrZZ%2BD%2FS%2BWRTNinP7J8lMjeQ%3D%3D"
    
    // 첫 네트워크 통신인지 아닌지 판별하는 변수
    var isFirstNetwork = true
    
    // json통신 후 모든 데이터 저장하는 변수
    var center_Info: Centers?
    
    // 시/도의 데이터만 저장하는 변수
    var sido_Info: [String] = []
    
    // 시/군/구의 데이터만 저장하는 변수
    var sigungu_Info: [String] = []
    
    // 피커뷰에 들어가는 데이터 저장하는 변수
    var pickerView_data: [String] = []
    
    // 시설명 데이터만 저장하는 변수
    var facilityName_Info: [String] = []
    
    init(viewController: UIViewController) {
        self.currentVC = viewController
    }
    
    // MARK: CUSTOM FUNCTION
    
    // 예방접종센터 조회
    func callCenterSearchService(page: Int = 1, perPage: Int = 10) {
        var param: [String: Any] = [:]
        param.updateValue(page, forKey: "page")
        param.updateValue(perPage, forKey: "perPage")
        param.updateValue(serviceKey, forKey: "serviceKey")
        
        RESTful.centerSearchNetwork(param, .get) { result, data, error in
            if result == -1 {
                if let err = error {
                    self.showAlert(title: "에러", message: err.localizedDescription, completionHandler: nil)
                }
            } else {
                if let model = data {
                    if self.isFirstNetwork {
                        self.callCenterSearchService(perPage: model.totalCount ?? 10)
                        self.isFirstNetwork = false
                    } else {
                        self.center_Info = model
                        if let centerInfo = self.center_Info {
                            if let data = centerInfo.data {
                                var sidoSet:Set<String> = []
                                for item in data {
                                    if let sido = item.sido {
                                        sidoSet.insert(sido)
                                    }
                                }
                                self.sido_Info = sidoSet.map {$0}.sorted()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    // 알람창 보여주기
    private func showAlert(title: String, message: String, completionHandler: ((UIAlertAction)-> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: completionHandler)
        
        alert.addAction(okAction)
        self.currentVC.present(alert, animated: true, completion: nil)
    }
    
    // 시군구 데이터 세팅
    func setSigungoData(_ sido: String) {
        var sigungoSet: Set<String> = []
        if let data = self.center_Info?.data {
            for item in data {
                if let item_sido = item.sido, sido.elementsEqual(item_sido) {
                    if let item_sigungu = item.sigungu {
                        sigungoSet.insert(item_sigungu)
                    }
                }
            }
        }
        self.sigungu_Info = sigungoSet.map{$0}.sorted()
    }
    
    // 시설명 데이터 세팅
    func setfacilityName(_ sido: String, _ sigungu: String) {
        self.facilityName_Info = []
        if let data = self.center_Info?.data {
            for item in data {
                if let item_sido = item.sido, let item_sigungu = item.sigungu, sido.elementsEqual(item_sido), sigungu.elementsEqual(item_sigungu) {
                    if let item_facilityName = item.facilityName {
                        self.facilityName_Info.append(item_facilityName)
                    }
                }
            }
        }
    }
}
