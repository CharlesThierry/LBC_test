# LBC_test

## Missing

* User alerts on network failure while refreshing, etc



## Structure

### UI

This App uses a CollectionViewController to display the Classified listing ads. Tapping on an item opens a detailed view of the ad in a DetailViewController presented through `showDetailViewController(_:sender:)`. The data of the Ad is directly provided by the MainViewController

In the Main controller, ads are sorted by is_urgent, then by date. It is possible to filter through category by using the dedicated Action button.


### Data storage

The downloaded data is stored using CoreData, because that's what it's for.

CoreData allows to leverage the relationships between objects on fetch and delete (although not as much as we'd want, see caveat), and to use the NSFetchedResultsController and its delegate to update the main controller collectionView


#### Caveat

Apparently, we can either guarantee the uniqueness of an entity (based on attribute), or have to-one mandatory relations between this entity and another, but not both.

This prevents us to guarantee the uniqueness of a Category or a Classified entity. I preferred to keep the to-one relation from Classified to Category mandatory, to avoid risking un-categorized Classified ads.

## Details

### ViewControllers

A CollectionView controller with the ads listing in collectionCells, which presents a plain old ViewController with the details on tap.

### Models

Model handles the initial https fetchs to category and listing. Once those are fetched, it converts the JSON received to xDescription (where x is Category, Image or Entry) and pushes them an instance of the DataManager, which it retains.

The DataManager handles all the CoreData interaction, by retaining the container, a store and a separate context (to avoid writes to it on the main thread). Writing takes places every few new items added to the context, to quickly show progress to the user.

Data is sent to the UI through a NSFetchedResultsController. In order to avoid putting CoreData knowledge in the UI, a interfacing layer (FetchResults) is created by the Model and given to the MainViewController.

FetchResults maintain two NSFetchedResultsController thinly wrapped in a generic class FetchController. This wrap allows the FetchResults to directly get the information to pass to the MainController.

In addition to isolate the CoreData layer, this interfacing layer concatenates the modifications received from the NSFetchedResultsController to present them in a single call to the UI.

