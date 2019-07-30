//
//  AcronymPersistence.swift
//  KituraRIL
//
//  Created by Chris Karani on 26/07/2019.
//

import Foundation
import CouchDB
import LoggerAPI

extension Acronym {
    class Persistence {
        static func getAll(from database: Database,
                           callback: @escaping (_ acronyms: [Acronym]?,_ error: Error?) -> Void ) {
            
            database.retrieveAll(includeDocuments: true) { (documents, error) in
                if let err = error {
                    Log.error("Error retrieving all documents: \(err.localizedDescription)")
                    return callback(nil, err)
                }
                let acronyms = documents?.decodeDocuments(ofType: Acronym.self)
                callback(acronyms, nil)
            }
            
        }
        
        static func save(_ acronym: Acronym, to database: Database,
                         callback: @escaping(_ acronym: Acronym?, _ error : Error?) -> Void) {
            Log.debug("Creating new acronym")
            database.create(acronym) { (document, error) in
                guard let doc = document else {
                    Log.error("Error creating new document: \(error!.localizedDescription)")
                    return callback(nil, error)
                }
                database.retrieve(doc.id, callback: callback)
            }
        }
        
        static func delete(_ acronymID: String, from database: Database,
                           callback: @escaping(_ error: Error?) -> Void) {
            database.retrieve(acronymID) { (acronym: Acronym?, error: CouchDBError?) in
                guard let acronym = acronym, let acronymRev = acronym._rev else {
                    Log.error("Error retrieving document: \(error!.localizedDescription)")
                    return callback(error)
                }
                database.delete(acronymID, rev: acronymRev, callback: callback)
            }
        }
        
        
    }
}
