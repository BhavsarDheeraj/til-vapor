import Fluent
import Vapor

struct CategoriesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categoriesRoutes = routes.grouped("api", "categories")
        categoriesRoutes.get(use: getAllHandler)
        categoriesRoutes.get(":categoryID", use: getHandler)
        categoriesRoutes.post(use: createHandler)
        categoriesRoutes.get(":categoryID", "acronyms", use: getAcronymsHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Category]> {
        return Category
            .query(on: req.db)
            .all()
    }
    
    func getHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        return Category
            .find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(Category.self)
        return category
            .save(on: req.db)
            .map { category }
    }
    
    func getAcronymsHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        return Category
            .find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                category
                    .$acronyms
                    .get(on: req.db) // same as .query(on: req.db).all()
            }
    }
}
