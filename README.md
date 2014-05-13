My Approach and Design Decision:

- I create two classes, PWSQLiteManager and PWPhotoManager, to specifically handle CRUD for the product, and storage or deletion of related photos. This makes my codes more compact and easier to read.

- In MacysDB.sql, there are two tables, one for storing products and the other is for providing mock data about stores.

- I intentionally to show only the regular price when the sale price is no less than the regular one, and add the strikethrough effect to emphasize when a product is indeed on sale.

Used Third-Party Libraries:

- FMDB: This popular Objective-C wrapper around SQLite makes the sqlite query or command execution convenient and robust.

- NSString+Color: Convert semantic strings (e.g. "red" or "yellow") into UIColor.

- MBProgressHUD: Indicate the status of finished work or work being done in a background thread.

- UIImage+Tools: Handle image resizing and orientation fixing.
