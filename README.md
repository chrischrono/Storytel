Storytel
======

This repository contains a sample app for requesting Storytel API, to search for books.


---
# Installation

To install the dependencies
* Open a terminal and cd to the directory containing the Podfile
* Run the `pod install` command

(For further details regarding cocoapod installation see https://cocoapods.org/)


---
# Existing Functionalities

The app is currently able to Search Books from Storytel API, and show it in tableView.

* When the app loads, it will Search the Books from Storytel API, and show them in the tableView
* Upon selecting the Query header, it will open a dialog box to input a new query, then it will try to refresh the list with related books based on the new query.

---
# Development Steps

1. Create new project based on single view app
2. Create folders for MVVM pattern
3. Add SearchBooksViewController and Design the UI layout to show Book List
4. Add Networking Layer to handle the Storytel API
5. Add Models and ViewModel, that will show the Book List at SearchBooksViewController
6. Add pods: Kingfisher
7. Add simple code to change query keyword
8. Add Unit Tests to test the process


