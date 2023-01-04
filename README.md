# Networking

-No pods
-No UI
-Self made Network with async await

-Usage instructions:

1 - fix todo to use code
-- add your domain

    var baseUrlString: String {
        // TODO: Set base url
        ""
    }
-- add your access token

    var idToken: String? {
        // TODO: Set auth token
        ""
    }

2 - create class with parent "NetworkController"

final class SomeServise: NetworkController {

}
    
3 - create descriptor sctuct for describe your request

struct GetSomeDataDescriptor: URLRequestDescriptor {
    typealias ResponseType = SomeDataModel
    typealias EncodedBodyType = SomeDataToPassToTheServer
    
    var httpMethod: URLHttpMethod { .post }
    var endPointPath: String
    var httpBody: HttpBody<SomeDataToPassToTheServer>
    
    init() {
        self.endPointPath = "restOfUrlIfNeedIt"
        self.httpBody = .init(model: SomeDataToPassToTheServer.init())
    }
}

4 - in your own class reated erlier create an async func

final class SomeServise: NetworkController {
    func getSomeData() async throws -> SomeDataModel {
        let descriptor = GetSomeDataDescriptor()
        return try await request(descriptor)
    }
}

-- in some case if you do not need data you can use emptyRequest

final class SomeServise: NetworkController {
    func getSomeData() async throws {
        let descriptor = GetSomeDataDescriptor()
        try await emptyRequest(descriptor)
    }
}

5 - Use your own request to get value 

Task {
    let data = try await SomeServise().getSomeData()
}

