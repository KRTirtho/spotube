# Lyrics Provider System

This directory contains the lyrics provider plugin system for Spotube.

## Architecture

The lyrics system is designed to be fully plugin-based, similar to the audio source and metadata plugins.

### Components

1. **lyrics_provider.dart** - Abstract interface for lyrics providers
2. **lyrics_provider_manager.dart** - Manages multiple lyrics providers
3. **providers/** - Built-in provider stubs (to be implemented as plugins)

## Plugin Integration

Lyrics plugins are loaded through the Hetu script system and must implement the following interface:

```dart
class LyricsEndpoint {
  Future<List<Map<String, dynamic>>> search(Map params);
  Future<Map<String, dynamic>?> getById(String id);
  Future<bool> isAvailable();
}
```

## Data Flow

```
User Request
    ↓
LyricsProviderManager
    ↓
Plugin System (Hetu)
    ↓
External API (LrcLib, Musixmatch, etc.)
    ↓
SubtitleSimple Model
    ↓
UI Display
```

## Creating a Lyrics Plugin

See `LYRICS_PLUGIN_GUIDE.md` in the root directory for detailed instructions.

### Quick Start

1. Create plugin.json with "abilities": ["lyrics"]
2. Implement LyricsEndpoint class in Hetu script
3. Compile to bytecode
4. Package as .smplug file
5. Distribute via GitHub releases

## Built-in Providers

The following providers are stubs that will be implemented as separate plugins:

- **LrcLibProvider** - Free, open lyrics database
- **MusixmatchProvider** - Commercial lyrics service (requires API key)

## Migration Notes

The old lyrics functionality has been removed from the main codebase and will be reimplemented as plugins. This allows:

- Community-contributed lyrics sources
- Easy addition of new providers
- No vendor lock-in
- Better separation of concerns
- Reduced main app size

## Future Enhancements

- Multiple provider fallback
- Lyrics caching
- Offline lyrics support
- User-contributed lyrics
- Lyrics translation
- Karaoke mode
