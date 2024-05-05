# DoubanParser
支持豆瓣电影电视图书解析

## Usage

```swift
import DoubanParser

let url = URL(string: "https://movie.douban.com/subject/26752088/")!

let parser = DoubanParser(url: url)

let result = await parser.parse()
```

## Parse Result

```swift
switch result {
    case .success(let media):
        switch media {
            case .movie(let movie):
                print(movie)
            case .tvSeries(let tvSeries):
                print(tvSeries)
            case .book(let book):
                print(book)
        }
    case .failure(let error):
        print(error)
}
// or
// let media = try? result.get()
```

