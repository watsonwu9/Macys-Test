My Approach and Design Decision:

- I design two classes, PWSQLiteManager and PWPhotoManager, to specifically handle CRUD operations for products, and storage or deletion of related product photos. Thus, my codes become more compact and much easier to read.

- Instead of storing photos as blob into the products table (this is generally a very bad design, of course), I choose to save them to the Documents directory and only their file links into the products table.

- In MacysDB.sql, I create two tables, one ("products") for storing products and the other ("stores") for providing mock data about all the stores. Meanwhile, mock data using JSON for the Product model is contained in the MockData.json file.

- I intentionally show only the regular price when the sale price is no less than the regular one. When a product is indeed on sale, I apply strikethrough effect onto the regular price label, and also red color to the sale price label for better visual appearance.

Used Third-Party Libraries:

- FMDB: Enable robust SQLite INSERT, SELECT, DELETE and UPDATE operations.

- NSString+Color: Convert semantic strings (e.g. "red" or "yellow") into UIColor.

- MBProgressHUD: Indicate the status of finished work or work being done in a background thread.

- UIImage+Tools: Handle image resizing and orientation fixing, for the photos taken through the camera.

Selected Screenshots:

![ScreenShot](https://raw.github.com/geek-paulwong/Macys-Test/master/ScreenShots/Photo-1.PNG)
![ScreenShot](https://raw.github.com/geek-paulwong/Macys-Test/master/ScreenShots/Photo-2.PNG)
![ScreenShot](https://raw.github.com/geek-paulwong/Macys-Test/master/ScreenShots/Photo-3.PNG)
![ScreenShot](https://raw.github.com/geek-paulwong/Macys-Test/master/ScreenShots/Photo-4.PNG)
![ScreenShot](https://raw.github.com/geek-paulwong/Macys-Test/master/ScreenShots/Photo-5.PNG)
