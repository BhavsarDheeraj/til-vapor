import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    try app.register(collection: AcronymsController())
    try app.register(collection: UsersController())
    try app.register(collection: CategoriesController())
}
