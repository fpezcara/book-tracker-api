module BookTestHelper
  def books_response
    {
      "items" => [
                  { "volumeInfo" =>{
                "title" => "The Story of the Little Mole Who Knew It Was None of His Business",
                "authors" => [
                  "Werner Holzwarth"
                ],
                "publishedDate" => "2024-10-10",
                "industryIdentifiers" => [
                  {
                    "type" => "ISBN_10",
                    "identifier" => "0008686130"
                  },
                  {
                    "type" => "ISBN_13",
                    "identifier" => "9780008686130"
                  }
                ],
                "pageCount" => 0,
                "imageLinks" => {
                  "smallThumbnail" => "http://books.google.com/books/content?id=qzEE0QEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
                  "thumbnail" => "http://books.google.com/books/content?id=qzEE0QEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
                },
                "previewLink" => "http://books.google.co.uk/books?id=qzEE0QEACAAJ&dq=intitle:little&hl=&cd=1&source=gbs_api",
                "infoLink" => "http://books.google.co.uk/books?id=qzEE0QEACAAJ&dq=intitle:little&hl=&source=gbs_api",
                "canonicalVolumeLink" => "https://books.google.com/books/about/The_Story_of_the_Little_Mole_Who_Knew_It.html?hl=&id=qzEE0QEACAAJ"
              }
            },
              { "volumeInfo" => {
                "title" => "Little Eyolf",
                "authors" => [
                  "Henrik Ibsen"
                ],
                "publishedDate" => "1895",
                "industryIdentifiers" => [
                  {
                    "type" => "OTHER",
                    "identifier" => "WISC:89006042303"
                  }
                ],
                "pageCount" => 230,
                "imageLinks" => {
                  "thumbnail" => "http://books.google.com/books/content?id=cbrnAAAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
                }
              } },
              { "volumeInfo" => {
                "title" => "Little Women",
                "authors" => [
                  "Louisa May Alcott"
                ],
                "publishedDate" => "2000",
                "industryIdentifiers" => [
                  {
                    type: "ISBN_10",
                    identifier: "0439101360"
                  },
                  {
                    type: "ISBN_13",
                    identifier: "9780439101363"
                  }
                ],
                "pageCount" => 580,
                "imageLinks" => {
                  "thumbnail" => "http://books.google.com/books/content?id=UwMH8v907NEC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
                }
      }
      }
            ]
    }
  end

  def expected_books_response
    [
        {
          "title" => "The Story of the Little Mole Who Knew It Was None of His Business",
          "authors" => [ "Werner Holzwarth" ],
          "published_date" => "2024-10-10",
          "page_count" => 0,
          "cover_image" => "http://books.google.com/books/content?id=qzEE0QEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
          "isbn" => "9780008686130"
        },
        {
          "title" => "Little Eyolf",
          "authors" => [ "Henrik Ibsen" ],
          "published_date" => "1895",
          "page_count" => 230,
          "cover_image" => "http://books.google.com/books/content?id=cbrnAAAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
          "isbn" => "WISC:89006042303"
        },
        {
          "title" => "Little Women",
          "authors" => [ "Louisa May Alcott" ],
          "published_date" => "2000",
          "page_count" => 580,
          "cover_image" => "http://books.google.com/books/content?id=UwMH8v907NEC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
          "isbn" =>  "9780439101363"
        }
      ]
  end
end
