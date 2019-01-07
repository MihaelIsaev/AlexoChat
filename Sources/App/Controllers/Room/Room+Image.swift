import Foundation
import Vapor
import FluentQuery

extension RoomController {
    
    func addImage(_ req: Request) throws -> Future<HTTPResponseStatus> {
        
        let directory = DirectoryConfig.detect()
        let workPath = directory.workDir
        
        let name = UUID().uuidString + ".jpg"
        let imageFolder = "Public/Rooms/Images"
        let saveURL = URL(fileURLWithPath: workPath).appendingPathComponent(imageFolder, isDirectory: true).appendingPathComponent(name, isDirectory: false)
        
        return try req.content.decode(FileContent.self).map { payload in
            do {
                try payload.image.data.write(to: saveURL)
                return .ok
            } catch {
                throw Abort(.internalServerError, reason: "Unable to write multipart form data to file. Underlying error \(error)")
            }
        }
    }
}
/*
 
 
 */
