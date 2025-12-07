# Lyrics Plugin Development Guide

This guide explains how to create a lyrics plugin for Spotube, similar to the existing audio source plugins.

## Overview

Spotube uses Hetu Script for its plugin system. Lyrics plugins are packaged as `.smplug` files (ZIP archives) containing:
- `plugin.json` - Plugin metadata and configuration
- `plugin.out` - Compiled Hetu bytecode
- `logo.png` - Optional plugin logo

## Plugin Structure

```
your-lyrics-plugin/
├── plugin.json          # Plugin configuration
├── src/
│   └── main.ht         # Hetu script source
├── logo.png            # Optional logo
└── README.md
```

## 1. Create plugin.json

```json
{
  "name": "LrcLib Lyrics",
  "author": "YourName",
  "description": "Lyrics provider using LrcLib API",
  "version": "1.0.0",
  "pluginApiVersion": "2.0.0",
  "entryPoint": "LrcLibLyricsPlugin",
  "repository": "https://github.com/yourusername/spotube-plugin-lrclib-lyrics",
  "apis": [],
  "abilities": ["lyrics"]
}
```

### Key Fields:
- `name`: Display name of your plugin
- `author`: Your name or organization
- `version`: Plugin version (semver)
- `pluginApiVersion`: Must be "2.0.0" for current Spotube
- `entryPoint`: Main class name in your Hetu script
- `abilities`: Must include "lyrics" for lyrics plugins
- `apis`: Empty array for lyrics plugins (used for metadata/audio plugins)

## 2. Write Hetu Script (src/main.ht)

```hetu
import 'package:spotube_plugin/spotube_plugin.dart'

class LrcLibLyricsPlugin {
  
  // Called when plugin is loaded
  LrcLibLyricsPlugin() {
    print('LrcLib Lyrics Plugin initialized')
  }

  // Lyrics API endpoint
  var lyrics = LyricsEndpoint()
}

class LyricsEndpoint {
  
  // Search for lyrics
  // Returns: List<Map<String, dynamic>>
  external fun search(Map params) async {
    final trackName = params['trackName']
    final artistName = params['artistName']
    final albumName = params['albumName']
    final duration = params['duration']  // in seconds
    
    // Make HTTP request to LrcLib API
    final url = 'https://lrclib.net/api/search?track_name=$trackName&artist_name=$artistName'
    
    final response = await http.get(url)
    final data = json.decode(response.body)
    
    // Transform to Spotube format
    final results = []
    for (var item in data) {
      results.add({
        'id': item['id'].toString(),
        'name': item['name'],
        'uri': 'lrclib:${item['id']}',
        'rating': item['rating'] ?? 0,
        'provider': 'lrclib',
        'lyrics': parseLrc(item['syncedLyrics'] ?? item['plainLyrics'])
      })
    }
    
    return results
  }
  
  // Get lyrics by ID
  // Returns: Map<String, dynamic> or null
  external fun getById(String id) async {
    final url = 'https://lrclib.net/api/get/$id'
    
    final response = await http.get(url)
    if (response.statusCode != 200) {
      return null
    }
    
    final data = json.decode(response.body)
    
    return {
      'id': data['id'].toString(),
      'name': data['name'],
      'uri': 'lrclib:${data['id']}',
      'rating': data['rating'] ?? 0,
      'provider': 'lrclib',
      'lyrics': parseLrc(data['syncedLyrics'] ?? data['plainLyrics'])
    }
  }
  
  // Check if service is available
  external fun isAvailable() async {
    try {
      final response = await http.get('https://lrclib.net/api/health')
      return response.statusCode == 200
    } catch (e) {
      return false
    }
  }
  
  // Parse LRC format to lyrics array
  fun parseLrc(String lrcContent) {
    if (lrcContent == null || lrcContent.isEmpty) {
      return []
    }
    
    final lines = lrcContent.split('\n')
    final lyrics = []
    
    for (var line in lines) {
      // Parse [mm:ss.xx] format
      final match = RegExp(r'\[(\d+):(\d+)\.(\d+)\](.*)').firstMatch(line)
      if (match != null) {
        final minutes = int.parse(match.group(1))
        final seconds = int.parse(match.group(2))
        final centiseconds = int.parse(match.group(3))
        final text = match.group(4).trim()
        
        final timeMs = (minutes * 60 + seconds) * 1000 + centiseconds * 10
        
        lyrics.add({
          'time': timeMs,
          'text': text
        })
      }
    }
    
    return lyrics
  }
}
```

## 3. Expected Data Format

### Search Parameters (input)
```dart
{
  'trackName': String,
  'artistName': String,
  'albumName': String?,  // optional
  'duration': int?       // optional, in seconds
}
```

### Search Results (output)
```dart
[
  {
    'id': String,
    'name': String,
    'uri': String,
    'rating': int,
    'provider': String,
    'lyrics': [
      {
        'time': int,  // milliseconds
        'text': String
      }
    ]
  }
]
```

## 4. Compile Plugin

### Install Hetu Compiler
```bash
dart pub global activate hetu_script_dev_tools
```

### Compile Script
```bash
hetu compile src/main.ht -o plugin.out
```

## 5. Package Plugin

Create a ZIP file with `.smplug` extension:
```bash
zip your-plugin.smplug plugin.json plugin.out logo.png
```

Or using PowerShell:
```powershell
Compress-Archive -Path plugin.json,plugin.out,logo.png -DestinationPath your-plugin.smplug
```

## 6. Test Plugin

1. Open Spotube
2. Go to Settings > Plugins
3. Click "Add Plugin"
4. Paste your plugin URL or select the `.smplug` file
5. Set as default lyrics provider

## 7. Distribute Plugin

### GitHub Release
1. Create a GitHub repository
2. Create a release with your `.smplug` file
3. Users can install by pasting the repo URL

### Direct Download
Host the `.smplug` file and share the direct download link

## Example Plugins to Reference

- **spotube-plugin-youtube-audio**: Audio source plugin
- **spotube-plugin-musicbrainz-listenbrainz**: Metadata plugin

## API Reference

### Available in Hetu Scripts

- `http.get(url)` - HTTP GET request
- `http.post(url, body)` - HTTP POST request
- `json.encode(obj)` - JSON encoding
- `json.decode(str)` - JSON decoding
- `localStorage.get(key)` - Get stored value
- `localStorage.set(key, value)` - Store value
- `print(message)` - Debug logging

## Common Issues

1. **Plugin API Version Mismatch**: Ensure `pluginApiVersion` is "2.0.0"
2. **Entry Point Not Found**: Class name must match `entryPoint` in plugin.json
3. **Compilation Errors**: Check Hetu syntax, use `external fun` for async methods
4. **Missing Abilities**: Must include "lyrics" in abilities array

## Testing Checklist

- [ ] Plugin loads without errors
- [ ] Search returns results for known songs
- [ ] Lyrics are time-synced correctly
- [ ] getById returns correct lyrics
- [ ] isAvailable returns true when service is up
- [ ] Handles network errors gracefully
- [ ] Works on all platforms (Windows, macOS, Linux, Android, iOS)

## Support

For questions and issues:
- Spotube Discord: https://discord.gg/spotube
- GitHub Issues: https://github.com/KRTirtho/spotube/issues
