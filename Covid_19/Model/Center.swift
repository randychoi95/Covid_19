//
//  Center.swift
//  Covid_19
//
//  Created by 최제환 on 2021/08/09.
//

import Foundation

class Centers: Codable {
    var page: Int?
    var perPage: Int?
    var totalCount: Int?
    var currentCount: Int?
    var data: [Center]?
}

class Center: Codable {
    var id: Int?                //        예방 접종 센터 고유 식별자
    
    var centerName: String?     //        예방 접종 센터 명
    
    var sido: String?           //        시도
    
    var sigungu: String?        //        시군구
    
    var facilityName: String?   //        시설명
    
    var zipCode: String?        //        우편번호
    
    var address: String?        //        주소
    
    var lat: String?            //        좌표(위도)
    
    var lng: String?            //        좌표(경도)
    
    var createdAt: String?
    var updatedAt: String?
    var centerType: String?     //        예방 접종 센터 유형
    
    var org: String?            //        운영기관
    
    var phoneNumber: String?    //        사무실 전화번호
}
