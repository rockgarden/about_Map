//
//  Photo.swift
//
//  Created by Wangkan on 18/07/16.
//  Copyright (c) 2016 Rockgarden. All rights reserved.
//

import Foundation

class Photo {

    var ident: Int
    var name: String
    var lat: String
    var lng: String
    var city: String
    var address: String
    var categoryName: String

    init(aIdent:Int, aName: String, aAddress: String,  aCity: String, aCategoryName: String, aLat: String, aLng: String){
        ident = aIdent
        name = aName
        address = aAddress
        city = aCity
        categoryName = aCategoryName
        lat = aLat
        lng = aLng
    }

}