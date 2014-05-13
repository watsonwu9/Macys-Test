My Approach and Design Decision:

- I design two classes, PWSQLiteManager and PWPhotoManager, to specifically handle CRUD for products, and storage or deletion of related photos. Thus, my codes become more compact and easier to read.

- In MacysDB.sql, there are two tables, one ("products") for storing products and the other ("stores") for providing mock data about stores. Mock data using JSON for the model Product is contained in MockData.json.

- I intentionally show only the regular price when the sale price is no less than the regular one, and apply strikethrough effect onto the regular price label and also red color to the sale price label when a product is indeed on sale.

Used Third-Party Libraries:

- FMDB: This popular Objective-C wrapper around SQLite makes the query or other command execution more convenient and robust.

- NSString+Color: Convert semantic strings (e.g. "red" or "yellow") into UIColor.

- MBProgressHUD: Indicate the status of finished work or work being done in a background thread.

- UIImage+Tools: Handle image resizing and orientation fixing, for the photos taken through the camera.
