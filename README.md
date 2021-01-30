# Favorite Beer

Get all beers from API. \
Show beers list, show information about each beer. \
Set favorite beers and show favorites list with sorting.

## Implementation

### Main controllers

BeersTableViewController shows all beers. Also can set favorites.\
FavoritesViewController shows favorites.\
BeerDetailsViewController shows information about selected beer.

## Requirements

 - Xcode 12
 - Swift 5
 - Core Data
 - iOS 13.0+

## Solution

When application loaded, data is trying to update. Also customer can update data from all beers screen, but data will be updated one time per one hour. Application can work in offline (if data has been loaded at least once).
