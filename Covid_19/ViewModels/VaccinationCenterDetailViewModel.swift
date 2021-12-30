//
//  VaccinationCenterDetailViewModel.swift
//  Covid_19
//
//  Created by 최제환 on 2021/12/30.
//

import Foundation

class VaccinationCenterDetailViewModel {
    
    // 예방접종 센터 정보
    var facility_Info: Center?
    
    init(facility_Info: Center?) {
        self.facility_Info = facility_Info
    }
    
    var name: String {
        return facility_Info?.facilityName ?? ""
    }
    
    var address: String {
        return facility_Info?.address ?? ""
    }
    
    var zipcode: String {
        return facility_Info?.zipCode ?? ""
    }
    
    var phoneNum: String {
        return facility_Info?.phoneNumber ?? ""
    }
    
    var lat: String {
        return facility_Info?.lat ?? ""
    }
    
    var lng: String {
        return facility_Info?.lng ?? ""
    }
}
