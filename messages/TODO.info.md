## TODO

### Search

Search is now running using elasticsearch (a proper search engine). Notes:

* Match is prefix per word unless a word is numeric - then it will exact match for psalm only in addition
* Search links (e.g. composer) will use only the first word - so e.g. clicking on Britten, Benjamin (1913-1976) will query for just "Britten".
* Match is an OR search. However - hits with more than one match should come higher in the results list

### Other

* Sorting of tables (js) and lists (session)
* Dropbox admin - files (link is coded)
* File upload
