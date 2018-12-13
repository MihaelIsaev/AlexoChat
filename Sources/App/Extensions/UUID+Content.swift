import Vapor

extension UUID: Content {
    /// See `Content`.
    public static var defaultContentType: MediaType {
        return .plainText
    }
}
