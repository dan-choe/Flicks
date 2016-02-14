# Project 1 - Flicks

Flicks is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 13 hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [ ] User sees an error message when there's a networking error.
- [ ] Movies are displayed using a CollectionView instead of a TableView.
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] Customize the UI.

The following **additional** features are implemented:

- [x] Add tab buttons to show the top rated movies
- [x] Load low resolution images first, then switch to high resolution images
- [x] Customized the navigation bar
- [x] User can see the detail view if the user clicks a movie on the list of movies

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Add optional tabs for genre
2. Notice if new movie is added

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://raw.githubusercontent.com/dan-choe/Flicks/master/flicks4.gif' title='Tip-Calculator' width='' alt='Tip-Calculator' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

After making basic functions, I tried to add a loading state. I installed MBProgressHUD, but it did not work at all.
I got up to 4 issues on Xcode. Therefore, I made all files again. 

## License

    Copyright [2016] [Dan Choe]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
