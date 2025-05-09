use Library
switched to db Library
db.createCollection("books")
{ ok: 1 }
db.books.insertMany([
  { title: "The Great Gatsby", author: "F. Scott Fitzgerald", year: 1925, genre: "Fiction", available: true },
  { title: "Moby-Dick", author: "Herman Melville", year: 1851, genre: "Adventure", available: true },
  { title: "To Kill a Mockingbird", author: "Harper Lee", year: 1960, genre: "Fiction", available: true },
  { title: "1984", author: "George Orwell", year: 1949, genre: "Dystopian", available: false },
  { title: "The Catcher in the Rye", author: "J.D. Salinger", year: 1951, genre: "Fiction", available: true }
])
{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId('681dc40efc0bd80b4db0cd2e'),
    '1': ObjectId('681dc40efc0bd80b4db0cd2f'),
    '2': ObjectId('681dc40efc0bd80b4db0cd30'),
    '3': ObjectId('681dc40efc0bd80b4db0cd31'),
    '4': ObjectId('681dc40efc0bd80b4db0cd32')
  }
}
db.books.find()
{
  _id: ObjectId('681dc40efc0bd80b4db0cd2e'),
  title: 'The Great Gatsby',
  author: 'F. Scott Fitzgerald',
  year: 1925,
  genre: 'Fiction',
  available: true
}
{
  _id: ObjectId('681dc40efc0bd80b4db0cd2f'),
  title: 'Moby-Dick',
  author: 'Herman Melville',
  year: 1851,
  genre: 'Adventure',
  available: true
}
{
  _id: ObjectId('681dc40efc0bd80b4db0cd30'),
  title: 'To Kill a Mockingbird',
  author: 'Harper Lee',
  year: 1960,
  genre: 'Fiction',
  available: true
}
{
  _id: ObjectId('681dc40efc0bd80b4db0cd31'),
  title: '1984',
  author: 'George Orwell',
  year: 1949,
  genre: 'Dystopian',
  available: false
}
{
  _id: ObjectId('681dc40efc0bd80b4db0cd32'),
  title: 'The Catcher in the Rye',
  author: 'J.D. Salinger',
  year: 1951,
  genre: 'Fiction',
  available: true
}
db.books.find({ year: { $gt: 1950 } })
{
  _id: ObjectId('681dc40efc0bd80b4db0cd30'),
  title: 'To Kill a Mockingbird',
  author: 'Harper Lee',
  year: 1960,
  genre: 'Fiction',
  available: true
}
{
  _id: ObjectId('681dc40efc0bd80b4db0cd32'),
  title: 'The Catcher in the Rye',
  author: 'J.D. Salinger',
  year: 1951,
  genre: 'Fiction',
  available: true
}
db.books.find({ year: { $gt: 1950 } })
{
  _id: ObjectId('681dc40efc0bd80b4db0cd30'),
  title: 'To Kill a Mockingbird',
  author: 'Harper Lee',
  year: 1960,
  genre: 'Fiction',
  available: true
}
{
  _id: ObjectId('681dc40efc0bd80b4db0cd32'),
  title: 'The Catcher in the Rye',
  author: 'J.D. Salinger',
  year: 1951,
  genre: 'Fiction',
  available: true
}
db.books.findOne({ title: "The Great Gatsby" })
{
  _id: ObjectId('681dc40efc0bd80b4db0cd2e'),
  title: 'The Great Gatsby',
  author: 'F. Scott Fitzgerald',
  year: 1925,
  genre: 'Fiction',
  available: true
}
db.books.updateOne(
  { title: "The Great Gatsby" },
  { $set: { year: 1926 } }
)
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
db.books.updateOne(
  { title: "Moby-Dick" },
  { $set: { available: false } }
)
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
db.books.updateMany(
  { available: true },
  { $set: { checked_out: false } }
)
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 3,
  modifiedCount: 3,
  upsertedCount: 0
}
db.books.updateMany(
  { genre: "Adventure" },
  { $set: { checked_out: true } }
)
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
db.books.deleteOne({ title: "1984" })
{
  acknowledged: true,
  deletedCount: 1
}
db.books.deleteMany({ year: { $lt: 1930 } })
