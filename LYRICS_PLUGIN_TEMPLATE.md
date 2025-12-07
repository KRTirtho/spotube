# Lyrics Plugin Template Repository

This document provides a complete template for creating a lyrics plugin repository.

## Repository Structure

```
spotube-plugin-lrclib-lyrics/
├── .github/
│   └── workflows/
│       └── release.yml
├── src/
│   └── main.ht
├── plugin.json
├── logo.png
├── README.md
├── LICENSE
└── .gitignore
```

## File Contents

### plugin.json

```json
{
  "name": "LrcLib Lyrics",
  "author": "YourName",
  "description": "Free and open-source lyrics provider using LrcLib API",
  "version": "1.0.0",
  "pluginApiVersion": "2.0.0",
  "entryPoint": "LrcLibLyricsPlugin",
  "repository": "https://github.com/yourusername/spotube-plugin-lrclib-lyrics",
  "apis": [],
  "abilities": ["lyrics"]
}
```

### src/main.ht

```hetu
import 'package:spotube_plugin/spotube_plugin.dart'

class LrcLibLyricsPlugin {
  
  LrcLibLyricsPlugin() {
    print('LrcLib Lyrics Plugin v1.0.0 initialized')
  }

  var lyrics = LyricsEndpoint()
}

class LyricsEndpoint {
  
  external fun search(Map params) async {
    final trackName = params['trackName']
    final artistName = params['artistName']
    final albumName = params['albumName']
    final duration = params['duration']
    
    var url = 'https://lrclib.net/api/search?track_name=${Uri.encodeComponent(trackName)}&artist_name=${Uri.encodeComponent(artistName)}'
    
    if (albumName != null && albumName.isNotEmpty) {
      url += '&album_name=${Uri.encodeComponent(albumName)}'
    }
    
    try {
      final response = await http.get(url)
      
      if (response.statusCode != 200) {
        print('LrcLib API error: ${response.statusCode}')
        return []
      }
      
      final data = json.decode(response.body)
      
      if (data is! List) {
        return []
      }
      
      final results = []
      for (var item in data) {
        final syncedLyrics = item['syncedLyrics']
        final plainLyrics = item['plainLyrics']
        
        if (syncedLyrics == null && plainLyrics == null) {
          continue
        }
        
        results.add({
          'uri': 'lrclib:${item['id']}',
          'name': '${item['trackName']} - ${item['artistName']}',
          'lyrics': parseLrc(syncedLyrics ?? plainLyrics ?? ''),
          'rating': 5,
          'provider': 'lrclib'
        })
      }
      
      return results
    } catch (e) {
      print('LrcLib search error: $e')
      return []
    }
  }
  
  external fun getById(String id) async {
    final url = 'https://lrclib.net/api/get/$id'
    
    try {
      final response = await http.get(url)
      
      if (response.statusCode != 200) {
        return null
      }
      
      final data = json.decode(response.body)
      final syncedLyrics = data['syncedLyrics']
      final plainLyrics = data['plainLyrics']
      
      if (syncedLyrics == null && plainLyrics == null) {
        return null
      }
      
      return {
        'uri': 'lrclib:${data['id']}',
        'name': '${data['trackName']} - ${data['artistName']}',
        'lyrics': parseLrc(syncedLyrics ?? plainLyrics ?? ''),
        'rating': 5,
        'provider': 'lrclib'
      }
    } catch (e) {
      print('LrcLib getById error: $e')
      return null
    }
  }
  
  external fun isAvailable() async {
    try {
      final response = await http.get('https://lrclib.net/')
      return response.statusCode == 200
    } catch (e) {
      return false
    }
  }
  
  fun parseLrc(String lrcContent) {
    if (lrcContent.isEmpty) {
      return []
    }
    
    final lines = lrcContent.split('\n')
    final lyrics = []
    
    for (var line in lines) {
      final timeMatch = RegExp(r'\[(\d+):(\d+)\.(\d+)\]').firstMatch(line)
      
      if (timeMatch != null) {
        final minutes = int.parse(timeMatch.group(1))
        final seconds = int.parse(timeMatch.group(2))
        final centiseconds = int.parse(timeMatch.group(3))
        
        final text = line.substring(timeMatch.end).trim()
        
        if (text.isNotEmpty) {
          final timeMs = (minutes * 60 + seconds) * 1000 + centiseconds * 10
          
          lyrics.add({
            'time': timeMs,
            'text': text
          })
        }
      }
    }
    
    return lyrics
  }
}
```

### README.md

```markdown
# LrcLib Lyrics Plugin for Spotube

Free and open-source lyrics provider using the LrcLib API.

## Features

- Time-synced lyrics
- Free and open-source
- No API key required
- Large lyrics database

## Installation

1. Open Spotube
2. Go to Settings > Plugins
3. Click "Add Plugin"
4. Paste: `https://github.com/yourusername/spotube-plugin-lrclib-lyrics`
5. Click Install

## Building

### Prerequisites
- Dart SDK
- Hetu Script Dev Tools

### Compile
```bash
dart pub global activate hetu_script_dev_tools
hetu compile src/main.ht -o plugin.out
```

### Package
```bash
zip spotube-plugin-lrclib-lyrics.smplug plugin.json plugin.out logo.png
```

## API

This plugin uses the [LrcLib API](https://lrclib.net/docs).

## License

MIT License
```

### .github/workflows/release.yml

```yaml
name: Release Plugin

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: dart-lang/setup-dart@v1
      
      - name: Install Hetu
        run: dart pub global activate hetu_script_dev_tools
      
      - name: Compile Plugin
        run: hetu compile src/main.ht -o plugin.out
      
      - name: Package Plugin
        run: zip spotube-plugin-lrclib-lyrics.smplug plugin.json plugin.out logo.png
      
      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: spotube-plugin-lrclib-lyrics.smplug
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### .gitignore

```
plugin.out
*.smplug
.DS_Store
```

## Publishing

1. Create repository on GitHub
2. Push code
3. Create a tag: `git tag v1.0.0`
4. Push tag: `git push origin v1.0.0`
5. GitHub Actions will automatically build and release

## Testing Locally

1. Compile: `hetu compile src/main.ht -o plugin.out`
2. Package: `zip plugin.smplug plugin.json plugin.out logo.png`
3. In Spotube, add plugin via file path

## Example Plugins

- [spotube-plugin-youtube-audio](https://github.com/KRTirtho/spotube/tree/master/assets/plugins/spotube-plugin-youtube-audio)
- [spotube-plugin-musicbrainz-listenbrainz](https://github.com/KRTirtho/spotube/tree/master/assets/plugins/spotube-plugin-musicbrainz-listenbrainz)
