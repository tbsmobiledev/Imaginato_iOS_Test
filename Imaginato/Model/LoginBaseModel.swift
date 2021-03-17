import Foundation
struct LoginBaseModel : Codable {
	let result : Int?
	let error_message : String?
	let data : UserData?

	enum CodingKeys: String, CodingKey {

		case result = "result"
		case error_message = "error_message"
		case data = "data"
	}

    init?() {
        return nil
    }
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		result = try values.decodeIfPresent(Int.self, forKey: .result)
		error_message = try values.decodeIfPresent(String.self, forKey: .error_message)
		data = try values.decodeIfPresent(UserData.self, forKey: .data)
	}
}

struct UserData : Codable {
    let user : User?

    enum CodingKeys: String, CodingKey {

        case user = "user"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(User.self, forKey: .user)
    }
}

struct User : Codable {
    let userId : Int?
    let userName : String?
    let created_at : String?
    let date : Date?

    init(userId:Int, userName:String,createdAt:String) {
        self.userId = userId
        self.userName = userName
        self.created_at = createdAt
        self.date = getDateFromString(self.created_at ?? "")
    }
    
    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case userName = "userName"
        case created_at = "created_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        date = getDateFromString(self.created_at ?? "")
    }
}
