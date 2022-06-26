//
//  DatabaseService.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import RealmSwift

protocol DatabaseService {

}

class DatabaseServiceImpl: DatabaseService {

     private var realm: Realm? {
         get { return try? Realm(configuration: .defaultConfiguration) }
     }

     func save<T: Object>(_ item: T) throws {
         try realm?.write({
             realm?.add(item)
         })
     }

     func save<T: Object>(_ items: [T]) throws {
         try realm?.write({
             realm?.add(items)
         })
     }

     func get<T: Object, KeyType>(_ type: T.Type, primaryKey: KeyType) throws -> T? {
         return realm?.object(ofType: type, forPrimaryKey: primaryKey)
     }

     func get<T: Object>(_ type: T.Type) throws -> Results<T>? {
         return realm?.objects(type)
     }

 }
 // MARK: - Clear
 extension DatabaseServiceImpl {

     func clear() {
         try? realm?.write({
             realm?.deleteAll()
         })
     }

     func clearPath() {
         guard let realm = realm, let objectsToDelete = try? get(LatLngObject.self) else { return }
         try? realm.write({
             realm.delete(objectsToDelete)
         })
     }
 }

 // MARK: - Get
 extension DatabaseServiceImpl {

     func getPath() -> [LatLng] {
         if let items = try? get(LatLngObject.self)?.sorted(byKeyPath: "id", ascending: true)  {
             return items.map({ LatLng($0) })
         }
         return [LatLng]()
     }
 }

 // MARK: - Save
 extension DatabaseServiceImpl {

     func savePath(_ items: [LatLng]) throws {
         if items.count == 0 { return }
         clearPath()
         try save(items.map({ LatLngObject($0) }))
     }
 }
