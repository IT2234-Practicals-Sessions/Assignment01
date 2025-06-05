# 📚 Library Database - MongoDB Summary

This README summarizes all MongoDB operations performed on the `Library` database and its `books` collection.

```javascript
// Use the Library database
use Library

// Create the books collection
db.createCollection("books")

// Insert multiple book documents
db.books.insertMany([
  { title: "The Great Gatsby", author: "F. Scott Fitzgerald", year: 1925, genre: "Fiction", available: true },
  { title: "Moby-Dick", author: "Herman Melville", year: 1851, genre: "Adventure", available: true },
  { title: "To Kill a Mockingbird", author: "Harper Lee", year: 1960, genre: "Fiction", available: true },
  { title: "1984", author: "George Orwell", year: 1949, genre: "Dystopian", available: false },
  { title: "The Catcher in the Rye", author: "J.D. Salinger", year: 1951, genre: "Fiction", available: true }
])

// Query all books
db.books.find()

// Find books published after 1950
db.books.find({ year: { $gt: 1950 } })

// Find a specific book by title
db.books.findOne({ title: "The Great Gatsby" })

// Update the year of a book
db.books.updateOne(
  { title: "The Great Gatsby" },
  { $set: { year: 1926 } }
)

// Mark Moby-Dick as unavailable
db.books.updateOne(
  { title: "Moby-Dick" },
  { $set: { available: false } }
)

// Set checked_out = false for all available books
db.books.updateMany(
  { available: true },
  { $set: { checked_out: false } }
)

// Set checked_out = true for Adventure genre books
db.books.updateMany(
  { genre: "Adventure" },
  { $set: { checked_out: true } }
)

// Delete a book by title
db.books.deleteOne({ title: "1984" })

// Delete books published before 1930
db.books.deleteMany({ year: { $lt: 1930 } })

