# Lyrics Plugin System Migration

This document explains the migration from built-in lyrics to a plugin-based system.

## What Changed

### Before
- Lyrics providers were built into the main application
- Hard-coded implementations for each service
- Required app updates to add new providers

### After
- Lyrics are provided through plugins
- Community can create providers for any service
- No app updates needed for new providers
- Follows the same pattern as audio source plugins

## Architecture

```
┌─────────────────────────────────────────┐
│         Spotube Main App                │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │   Lyrics Plugin Interface         │ │
│  │   (MetadataPluginLyricsEndpoint)  │ │
│  └───────────────────────────────────┘ │
│                  ↓                      │
│  ┌───────────────────────────────────┐ │
│  │   Hetu Script Engine              │ │
│  └───────────────────────────────────┘ │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      Lyrics Plugin (.smplug)            │
│                                         │
│  - plugin.json (metadata)               │
│  - plugin.out (compiled Hetu bytecode)  │
│  - logo.png (optional)                  │
│                                         │
│  Implements:                            │
│  - search(params) → List<Lyrics>        │
│  - getById(id) → Lyrics?                │
│  - isAvailable() → bool                 │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      External Lyrics API                │
│  (LrcLib, Musixmatch, Genius, etc.)     │
└─────────────────────────────────────────┘
```

## Main App Changes

### Added Files
- `lib/services/metadata/endpoints/lyrics.dart` - Lyrics endpoint interface
- `lib/provider/lyrics_plugin_provider.dart` - Riverpod providers for lyrics
- `lib/services/lyrics_provider/README.md` - Documentation
- `LYRICS_PLUGIN_GUIDE.md` - Plugin development guide
- `LYRICS_PLUGIN_TEMPLATE.md` - Template repository structure
- `LYRICS_PLUGIN_MIGRATION.md` - This file

### Modified Files
- `lib/models/metadata/plugin.dart` - Added `lyrics` to `PluginAbilities` enum
- `lib/services/metadata/metadata.dart` - Added lyrics endpoint initialization

### Removed Files
- All built-in lyrics provider implementations (moved to plugins)

## Plugin Development

### Quick Start
1. Clone template: `LYRICS_PLUGIN_TEMPLATE.md`
2. Implement Hetu script in `src/main.ht`
3. Compile: `hetu compile src/main.ht -o plugin.out`
4. Package: `zip plugin.smplug plugin.json plugin.out logo.png`
5. Publish on GitHub with releases

### Required Methods

```hetu
class LyricsEndpoint {
  external fun search(Map params) async
  external fun getById(String id) async
  external fun isAvailable() async
}
```

### Data Format

**Input (search params):**
```dart
{
  'trackName': String,
  'artistName': String,
  'albumName': String?,
  'duration': int?  // seconds
}
```

**Output (lyrics):**
```dart
{
  'uri': String,
  'name': String,
  'lyrics': [
    {
      'time': int,  // milliseconds
      'text': String
    }
  ],
  'rating': int,
  'provider': String
}
```

## Usage in Main App

### Get Lyrics Plugin
```dart
final plugin = ref.watch(lyricsPluginProvider);
```

### Search Lyrics
```dart
final lyrics = await ref.read(lyricsSearchProvider({
  'trackName': 'Song Name',
  'artistName': 'Artist Name',
  'albumName': 'Album Name',
  'duration': Duration(seconds: 180),
}).future);
```

### Get by ID
```dart
final lyric = await ref.read(lyricsByIdProvider('lrclib:12345').future);
```

## Plugin Examples

### LrcLib Plugin
- Free, open-source
- No API key required
- Repository: Create at `spotube-plugin-lrclib-lyrics`

### Musixmatch Plugin
- Commercial service
- Requires API key
- Repository: Create at `spotube-plugin-musixmatch-lyrics`

### Genius Plugin
- Community lyrics
- Web scraping or API
- Repository: Create at `spotube-plugin-genius-lyrics`

## Benefits

1. **Extensibility**: Anyone can add new lyrics sources
2. **Maintainability**: Plugins maintained separately
3. **Flexibility**: Users choose their preferred provider
4. **Privacy**: No forced third-party services
5. **Community**: Encourages community contributions
6. **Updates**: Plugins update independently

## Migration Path for Users

1. Update Spotube to version with plugin support
2. Install lyrics plugin from Settings > Plugins
3. Choose default lyrics provider
4. Existing lyrics cache remains compatible

## For Plugin Developers

### Resources
- Plugin Guide: `LYRICS_PLUGIN_GUIDE.md`
- Template: `LYRICS_PLUGIN_TEMPLATE.md`
- Example: Check `assets/plugins/spotube-plugin-youtube-audio/`
- Hetu Docs: https://hetu.dev

### Testing
1. Compile plugin locally
2. Load in Spotube via file path
3. Test search and getById methods
4. Verify time-sync accuracy
5. Test error handling

### Publishing
1. Create GitHub repository
2. Add GitHub Actions for auto-build
3. Create release with `.smplug` file
4. Users install via repo URL

## Support

- Discord: https://discord.gg/spotube
- GitHub: https://github.com/KRTirtho/spotube
- Docs: https://spotube.krtirtho.dev

## Future Enhancements

- Multiple provider fallback
- Provider priority settings
- Lyrics caching system
- Offline lyrics support
- User-contributed lyrics
- Lyrics translation plugins
- Karaoke mode plugins
