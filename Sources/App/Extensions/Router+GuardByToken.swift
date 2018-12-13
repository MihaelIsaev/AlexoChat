import Vapor

extension Router {
    func guardedByToken() -> Router {
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        return grouped(tokenAuthMiddleware, guardAuthMiddleware)
    }
}
