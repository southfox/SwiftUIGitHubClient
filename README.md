# SwiftUIGitHubClient
Swift UI Github Client

## Reason
The objective of this is to create a straightforward, single-screen application that displays the latest trending repositories on Github, using data sourced from a public API. And this is a Minimum Viable Product (MVP).

## Architecture
SwiftUI, just MVC without the C, that means MV (declarative, post-reactive).
Unit Tests enabled.
iOS16 minimum
Core Data
Animations: Lottie (on error) & Shimmer (loading)
Settings: use cache / dark mode / expanded mode

## Public API
Here is the Github public api (https://api.github.com/search/repositories?q=language=+sort:stars)
We are going to use only reduced information of every repository item:
* Name: items[].name
* Full Name: items[].full_name
* Description: items[].description
* Owner avatar url (icon): items[].owner.avatar_url
* Language: items[].language
* Number of starts: items[].stargazers_count
  
<details>
  <summary>Example: </summary>
   
  
```json
{
  "items": [
  {
      "name": "go",
      "full_name": "golang/go",
      "description": "The Go programming language"
      "owner": {
        "avatar_url": "https://avatars.githubusercontent.com/u/4314092?v=4"
      },
      "language": "Go",
      "stargazers_count": 119467
  }]
}
```
</details>


## The app
It fetchs the trending repositories from the provided public API and display it to the users, it uses cache, but the user could refresh the information.
CoreData helps to show cached information.

### Use Case
![Use Case](assets/UseCase.png)

<details>
  <summary>use case in plant uml</summary>
  
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
  usecase "Use Cache On/Off" as isCacheMode
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
Settings --> isCacheMode
@enduml
```

</details>

## Model View (MV)
In SwiftUI we are going to use a natural way, there's no need of MVVM here, we just adopt MV.
* In app, we store and process data by using a data model that is separate from it's UI, Data & Logic will be inside Repository.
* Adopting the ObservableObject protocol for model class (Repository).
* Use ObservableObject where we need to manager the life cycle of the data.
* Typically the ObservableObject is part of the model.

![Mind Map](assets/MindMap.png)


<details>
  <summary>Mind map of the model in plantuml</summary>
  
```plantuml
@startmindmap
* Repository List
** Repository Info
** Repository Extended Detail
@endmindmap
```
</details>

## Sequence

Sequence diagram of the app.

![Sequence Diagram](assets/SequenceDiagram.png)

<details>
  <summary>Sequence in plantuml</summary>
  
```plantuml
@startuml
actor User
box "iOS Application" #LightBlue
participant VM
participant Settings
participant CoreData
end box
participant GitHub

== initialization ==
VM -> Settings: isCache
Settings -> CoreData: settings
CoreData --> Settings: settings
Settings --> VM: cache on/off

== case error ==
User -> VM : refresh
VM ->x GitHub : request: getRepos
VM --> User: loading
VM --> User: error
VM --> Settings: isCacheEnabled
Settings -> CoreData: getCache
CoreData --> Settings: cache on/off
Settings --> VM: cache on/off
== with cache ==
Settings --> VM: cache = on
VM -> CoreData: getReposFromDB
CoreData --> VM: Repos
VM --> User: Repos
== with no cache ==
Settings --> VM: cache = off
VM -> User: retry/cancel?
== case success ==
User -> VM : refresh
VM -> GitHub : request: getRepos
VM --> User: loading
GitHub --> VM : response: getRepos
VM --> User: response
== tap on a cell ==
User -> VM : tap
VM -> User: expand cell
== tap on settings ==
User -> VM : tap
VM -> Settings: go to settings view
Settings -> CoreData: get settings
CoreData -> Settings: settings
Settings -> VM: settings
VM -> User: settings view
== settings view ==

@enduml
```
</details>

## Screenshots

### MVP loading
![MVP Loading](assets/AppLoading.png)

### MVP network success
![MVP Running Success](assets/MVPRunningSuccess.png)

### MVP cell expanded
![Cell Expanded](assets/CellExpanded.png)

### MVP network failed
![Network Failure](assets/NetworkFailure.png)

### MVP Settings
![App Settings Cache](assets/AppSettingsCache.png)

## Tests

![Tests](assets/Tests.png)

### Unit Tests

#### Coverage

#### Coverage

![Unit Test Coverage](assets/UnitTestCoverage.png)
