import SwiftUI
import SwiftData

@Model
class Person {
    let name: String
    let favoriteColor: String?

    init(name: String) {
        self.name = name
    }
}

@main
struct SwiftDataBasicsApp: App {

    @MainActor
    func setupDatabase() async {
        let schema = Schema([Person.self])
        let config = ModelConfiguration(
            "SwiftDataBasics",
            schema: schema
        )
        print(config.url.path(percentEncoded: false))

        let container = try! ModelContainer(for: Person.self, configurations: config)

        let person = Person(name: "Ted Lasso")
        let context = container.mainContext
        context.insert(person)
        try! context.save()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
//                 a lot of magic here
//                .modelContainer(for: [Person.self])
                .task {
                    await setupDatabase()
                }
        }
    }
}
