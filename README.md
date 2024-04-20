# SwiftUIGitHubClient
Swift UI Github Client

## Reason
The objective of this is to create a straightforward, single-screen application that displays the latest trending repositories on Github, using data sourced from a public API. And this is a Minimum Viable Product (MVP).

## Architecture
Swift / SwiftUI
iOS16 minimum
Core Data
Animations: Lottie (on error) & Shimmer (loading)
Settings: use cache / show animation

## The app
It fetchs the trending repositories from the provided public API and display it to the users, it uses cache, but the user could refresh the information.
CoreData helps to show cached information.

<details>
  <summary>Use Cases</summary>
  
  ### plantuml
```plantuml
@startuml
left to right direction
actor User as u
package "Unit Test" {
  actor "Automation" as fc
}
package Application {
  usecase "Open" as UC1
  usecase "Refresh" as UC2
  usecase "Test" as UC4
  database CoreData as CD
  component Cache
  component Animation
  component Settings
  usecase "Dark Mode" as DM
  usecase "Expanded Mode" as EM
}
package GitHub {
  usecase "Repositories" as Rep
  database Database as DB
}

fc --> UC4
u --> UC1
UC1 --> UC2
u --> UC2
UC2 --> Rep
UC2 --> Cache
Rep --> DB
Cache --> CD
Settings --> DM
Settings --> EM
@enduml
```

</details>

