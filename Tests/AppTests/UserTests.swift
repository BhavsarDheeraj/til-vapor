@testable import App
import XCTVapor
import XCTest

final class UserTests: XCTestCase {
    
//    let usersName = "Alice"
//    let usersUsername = "alicea"
//    let usersURI = "/api/users/"
//    var app: Application!
//    
//    override func setUpWithError() throws {
//        app = try Application.testable()
//    }
//    
//    override func tearDownWithError() throws {
//        app.shutdown()
//    }
//    
//    func testUsersCanBeRetrievedFromAPI() throws {
//        let user = try User.create(name: usersName, username: usersUsername, on: app.db)
//        _ = try User.create(on: app.db)
//        
//        try app.test(.GET, usersURI) { response in
//            XCTAssertEqual(response.status, .ok)
//            let users = try response.content.decode([User].self)
//            
//            XCTAssertEqual(users.count, 2)
//            XCTAssertEqual(users[0].name, usersName)
//            XCTAssertEqual(users[0].username, usersUsername)
//            XCTAssertEqual(users[0].id, user.id)
//        }
//    }
//    
//    func testUserCanBeSavedWithAPI() throws {
//        let user = User(name: usersName, username: usersUsername)
//        
//        try app.test(.POST, usersURI, beforeRequest: { req in
//            try req.content.encode(user)
//        }, afterResponse: { response in
//            let receivedUser = try response.content.decode(User.self)
//            
//            XCTAssertEqual(receivedUser.name, usersName)
//            XCTAssertEqual(receivedUser.username, usersUsername)
//            XCTAssertNotNil(receivedUser.id)
//            
//            try app.test(.GET, usersURI) { secondResponse in
//                let users = try secondResponse.content.decode([User].self)
//                XCTAssertEqual(users.count, 1)
//                XCTAssertEqual(users[0].name, receivedUser.name)
//                XCTAssertEqual(users[0].username, receivedUser.username)
//                XCTAssertEqual(users[0].id, receivedUser.id)
//            }
//        })
//    }
//    
//    func testGettingASingleUserWithAPI() throws {
//        let user = try User.create(name: usersName, username: usersUsername, on: app.db)
//        
//        try app.test(.GET, "\(usersURI)\(user.id!)", afterResponse: { response in
//            let receivedUser = try response.content.decode(User.self)
//            XCTAssertEqual(receivedUser.name, usersName)
//            XCTAssertEqual(receivedUser.username, usersUsername)
//            XCTAssertEqual(receivedUser.id, user.id)
//        })
//    }
    
}
