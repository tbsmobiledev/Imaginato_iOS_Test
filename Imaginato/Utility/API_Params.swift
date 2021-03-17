import Foundation

let baseUrl                         = "http://imaginato.mocklab.io/"

struct Params {
    struct Login {
        static let URL              = baseUrl + "login"
        static let email            = "email"
        static let password         = "password"
    }
}
