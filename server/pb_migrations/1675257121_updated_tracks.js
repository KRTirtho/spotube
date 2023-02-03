migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("pevn93oxbnovw0s")

  collection.createRule = "@request.auth.id != '' && ((spotify_id ?= @collection.tracks.spotify_id && youtube_id ?= @collection.tracks.youtube_id) || (spotify_id ?!= @collection.tracks.spotify_id && youtube_id ?!= @collection.tracks.youtube_id))"
  collection.updateRule = "@request.auth.id != '' && ((spotify_id ?= @collection.tracks.spotify_id && youtube_id ?= @collection.tracks.youtube_id) || (spotify_id ?!= @collection.tracks.spotify_id && youtube_id ?!= @collection.tracks.youtube_id))"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("pevn93oxbnovw0s")

  collection.createRule = null
  collection.updateRule = null

  return dao.saveCollection(collection)
})
