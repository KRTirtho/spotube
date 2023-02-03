migrate((db) => {
  const collection = new Collection({
    "id": "pevn93oxbnovw0s",
    "created": "2023-02-01 13:01:08.893Z",
    "updated": "2023-02-01 13:01:08.893Z",
    "name": "tracks",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "ycnix0ai",
        "name": "spotify_id",
        "type": "text",
        "required": true,
        "unique": false,
        "options": {
          "min": 20,
          "max": 22,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "ih8fxzgh",
        "name": "youtube_id",
        "type": "text",
        "required": true,
        "unique": false,
        "options": {
          "min": 10,
          "max": 11,
          "pattern": ""
        }
      },
      {
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
      }
    ],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("pevn93oxbnovw0s");

  return dao.deleteCollection(collection);
})
