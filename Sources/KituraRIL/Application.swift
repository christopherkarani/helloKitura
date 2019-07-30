//
//  File.swift
//  KituraRIL
//
//  Created by Chris Karani on 23/07/2019.
//

import Foundation
import Kitura
import LoggerAPI
import CouchDB


enum DatabaseStrings:String {
    case acronyms = "acronym"
}

public class App {
    
    var client : CouchDBClient!
    var database: Database!
    
    let router = Router()
    
    private func createNewDatabase() {
        client.createDB(DatabaseStrings.acronyms.rawValue) { (couchDB, error) in
            guard let db = couchDB else {
                Log.error("""
                    Could not create new database:
                     (\(String(describing: error!.reason)))
                     - acronym routes not created
                    """)
                return
            }
            self.finalizeRoutes(with: db)
        }
    }
    
    private func postInit() {
        let conncectionProperties = ConnectionProperties(host: "localhost",
                                                         port: 5984,
                                                         secured: false)
        client = CouchDBClient(connectionProperties: conncectionProperties)
        client.retrieveDB(DatabaseStrings.acronyms.rawValue) { (db, error) in
            guard let couchDB = db else {
                Log.info("""
                    Could not retrieve acronyms database,
                    \(String.init(describing: error!.reason)),
                    attempting to create a new one
                    """)
                self.createNewDatabase()
                return
            }
            Log.info("Acronyms database located - loading...")
            self.finalizeRoutes(with: couchDB)
        }
    }
    
    private func finalizeRoutes(with database: Database) {
        self.database = database
        initializeAcronymRoutes(app: self)
        Log.info("Acronym routes created")
    }
    
    public func run()  {
        postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }
}
