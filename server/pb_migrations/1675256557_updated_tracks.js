migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("pevn93oxbnovw0s")

  collection.listRule = ""
  collection.viewRule = ""

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("pevn93oxbnovw0s")

  collection.listRule = null
  collection.viewRule = null

  return dao.saveCollection(collection)
})
