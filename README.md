# FlickPic
An interesting demo app, which shows images separated in 3 column based on Flickr API. This should give a basic idea on how to implement a collection view with infinite scrolling images. 

`Note:` By default it will search with Kittens but you can clear it as per your need.

![alt text][demo]

## Main features :

* `Infinite scrolling.`
* `Async image loading.`
* `Caching to save internet data.`
* `Get images in medium size to reduce wastage of data.`
* `Unit test code added.`

## TODO

* Refactor the URLSession code to make it reusable inside Network file.
* Collection view is currently using the reload method to update the contents. This should be added from the bottom instead of reloading whole list.


## Information

Since latest iOS version supports the HTTP/2 and flickr API too supports it. It loads image faster then the older version of HTTP. Test here https://tools.keycdn.com/http2-test



[demo]: https://github.com/mdaslamansari2008/Flick-Pic/blob/master/ReadMeAsset/demo.gif "Demonstration of current app"
