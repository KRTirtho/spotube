migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("pevn93oxbnovw0s")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "vzvqgsjf",
    "name": "votes",
    "type": "number",
    "required": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("pevn93oxbnovw0s")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "vzvqgsjf",
    "name": "votes",
    "type": "number",
    "required": true,
    "unique": false,
    "options": {
      "min": null,
      "max": null
    }
  }))

  return dao.saveCollection(collection)
})
