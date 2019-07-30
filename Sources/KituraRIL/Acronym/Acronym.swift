//
//  Acronym.swift
//  KituraRIL
//
//  Created by Chris Karani on 23/07/2019.
//

import CouchDB

struct Acronym: Document {
    var _id: String?
    
    var _rev: String?
    
    var short: String
    var long: String
}
