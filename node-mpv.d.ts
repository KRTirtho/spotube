// Type definitions for node-mpv 2.0-beta.0
// Project: node-mpv <https://github.com/j-holub/Node-MPV>
// Definitions by: leonekmi <me@leonekmi.fr>

declare module "node-mpv" {
  import EventEmitter = NodeJS.EventEmitter;

  interface NodeMpvOptions {
    // Print debug lines
    debug?: boolean;
    // Print more lines
    verbose?: boolean;
    // Specify socket
    socket?: string;
    // Don't open video display
    audio_only?: boolean;
    // Auto-restart on a crash
    auto_restart?: boolean;
    // Time update for timeposition event
    time_update?: number;
    // Path to mpv binary
    binary?: string;
  }

  /*interface NodeMpvError {

}*/

  // these are the emitted events
  type EventNames = "crashed" | "getrequest" | "seek" | "started" | "stopped" | "paused" | "resumed" | "status" | "timeposition" | "quit";
  type VoidCallback = () => void;
  type VoidCallbackWithData<ArgType> = (arg: ArgType) => void;
  type VoidCallbackWithData2<ArgType, ArgType2> = (arg: ArgType, arg2: ArgType2) => void;

  type LoadMode = "replace" | "append";
  type MediaLoadMode = LoadMode | "append-play";
  type AudioFlag = "select" | "auto" | "cached";
  type SeekMode = "relative" | "absolute";
  type RepeatMode = number | "inf" | "no";
  type PlaylistMode = "weak" | "force";

  interface TimePosition {
    start: number;
    end: number;
  }
  type StatusObjectProperties = "mute" | "pause" | "duration" | "volume" | "filename" | "path" | "media-title" | "playlist-pos" | "playlist-count" | "loop" | "fullscreen" | "sub-visibility";

  interface StatusObject {
    property: StatusObjectProperties;
    value: string | number | boolean;
  }

  type EventListenerArgs<EventName extends EventNames> = [EventName, VoidCallback];
  type EventListenerArgsWithData<EventName extends EventNames, DataType> = [EventName, VoidCallbackWithData<DataType>];
  type EventListenerArgsWithMultipleData<EventName extends EventNames, DataType, DataType1> = [EventName, VoidCallbackWithData2<DataType, DataType1>];

  export default class NodeMpv implements EventEmitter {
    /**
     * Listen to certain events which are emitted after any kind of
     * status change of mpv player.
     * @param args
     * @see for Events https://github.com/j-holub/Node-MPV#events
     */

    addListener(...args: EventListenerArgs<"crashed">): this;
    addListener(...args: EventListenerArgsWithMultipleData<"getrequest", string, any>): this;
    addListener(...args: EventListenerArgs<"paused">): this;
    addListener(...args: EventListenerArgs<"quit">): this;
    addListener(...args: EventListenerArgs<"resumed">): this;
    addListener(...args: EventListenerArgsWithData<"seek", TimePosition>): this;
    addListener(...args: EventListenerArgs<"started">): this;
    addListener(...args: EventListenerArgsWithData<"status", StatusObject>): this;
    addListener(...args: EventListenerArgs<"stopped">): this;
    addListener(...args: EventListenerArgsWithData<"timeposition", number>): this;

    /**
     * Listen to certain events which are emitted after any kind of
     * status change of mpv player
     * @param args
     * @see for Events https://github.com/j-holub/Node-MPV#events
     */
    on(...args: EventListenerArgs<"crashed">): this;
    on(...args: EventListenerArgsWithMultipleData<"getrequest", string, any>): this;
    on(...args: EventListenerArgs<"paused">): this;
    on(...args: EventListenerArgs<"quit">): this;
    on(...args: EventListenerArgs<"resumed">): this;
    on(...args: EventListenerArgsWithData<"seek", TimePosition>): this;
    on(...args: EventListenerArgs<"started">): this;
    on(...args: EventListenerArgsWithData<"status", StatusObject>): this;
    on(...args: EventListenerArgs<"stopped">): this;
    on(...args: EventListenerArgsWithData<"timeposition", number>): this;

    /**
     * Listen to certain events which are emitted after any kind of
     * status change of mpv player
     * @param args
     * @see for Events https://github.com/j-holub/Node-MPV#events
     */
    once(...args: EventListenerArgs<"crashed">): this;
    once(...args: EventListenerArgsWithMultipleData<"getrequest", string, any>): this;
    once(...args: EventListenerArgs<"paused">): this;
    once(...args: EventListenerArgs<"quit">): this;
    once(...args: EventListenerArgs<"resumed">): this;
    once(...args: EventListenerArgsWithData<"seek", TimePosition>): this;
    once(...args: EventListenerArgs<"started">): this;
    once(...args: EventListenerArgsWithData<"status", StatusObject>): this;
    once(...args: EventListenerArgs<"stopped">): this;
    once(...args: EventListenerArgsWithData<"timeposition", number>): this;

    /**
     * Remove listener that is listening to the provided event `eventName`
     * @param args
     */
    off(...args: EventListenerArgs<"crashed">): this;
    off(...args: EventListenerArgsWithMultipleData<"getrequest", string, any>): this;
    off(...args: EventListenerArgs<"paused">): this;
    off(...args: EventListenerArgs<"quit">): this;
    off(...args: EventListenerArgs<"resumed">): this;
    off(...args: EventListenerArgsWithData<"seek", TimePosition>): this;
    off(...args: EventListenerArgs<"started">): this;
    off(...args: EventListenerArgsWithData<"status", StatusObject>): this;
    off(...args: EventListenerArgs<"stopped">): this;
    off(...args: EventListenerArgsWithData<"timeposition", number>): this;

    /**
     * Remove listener that is listening to the provided event `eventName`
     * @param args
     */
    removeListener(...args: EventListenerArgs<"crashed">): this;
    removeListener(...args: EventListenerArgsWithMultipleData<"getrequest", string, any>): this;
    removeListener(...args: EventListenerArgs<"paused">): this;
    removeListener(...args: EventListenerArgs<"quit">): this;
    removeListener(...args: EventListenerArgs<"resumed">): this;
    removeListener(...args: EventListenerArgsWithData<"seek", TimePosition>): this;
    removeListener(...args: EventListenerArgs<"started">): this;
    removeListener(...args: EventListenerArgsWithData<"status", StatusObject>): this;
    removeListener(...args: EventListenerArgs<"stopped">): this;
    removeListener(...args: EventListenerArgsWithData<"timeposition", number>): this;

    /**
     * Removes all listeners listening to a particular event `eventName`
     * @param {EventNames?} event - Event names
     */

    removeAllListeners(event?: EventNames): this;

    setMaxListeners(n: number): this;

    getMaxListeners(): number;

    listeners(event: EventNames): Function[];

    rawListeners(event: EventNames): Function[];
    emit(event: EventNames, ...args: any[]): boolean;
    listenerCount(event: EventNames): number;
    // Added in Node 6...
    prependListener(...args: EventListenerArgs<"crashed">): this;
    prependListener(...args: EventListenerArgsWithMultipleData<"getrequest", string, any>): this;
    prependListener(...args: EventListenerArgs<"paused">): this;
    prependListener(...args: EventListenerArgs<"quit">): this;
    prependListener(...args: EventListenerArgs<"resumed">): this;
    prependListener(...args: EventListenerArgsWithData<"seek", TimePosition>): this;
    prependListener(...args: EventListenerArgs<"started">): this;
    prependListener(...args: EventListenerArgsWithData<"status", StatusObject>): this;
    prependListener(...args: EventListenerArgs<"stopped">): this;
    prependListener(...args: EventListenerArgsWithData<"timeposition", number>): this;

    prependOnceListener(...args: EventListenerArgs<"crashed">): this;
    prependOnceListener(...args: EventListenerArgsWithMultipleData<"getrequest", string, any>): this;
    prependOnceListener(...args: EventListenerArgs<"paused">): this;
    prependOnceListener(...args: EventListenerArgs<"quit">): this;
    prependOnceListener(...args: EventListenerArgs<"resumed">): this;
    prependOnceListener(...args: EventListenerArgsWithData<"seek", TimePosition>): this;
    prependOnceListener(...args: EventListenerArgs<"started">): this;
    prependOnceListener(...args: EventListenerArgsWithData<"status", StatusObject>): this;
    prependOnceListener(...args: EventListenerArgs<"stopped">): this;
    prependOnceListener(...args: EventListenerArgsWithData<"timeposition", number>): this;

    eventNames(): Array<string | symbol>;

    /**
     * A mpv wrapper for node
     *
     * @param options - Tweak NodeMPV behaviour
     * @param mpv_args - Arrays of CLI options to pass to mpv. IPC options are automatically appended.
     */
    constructor(options?: NodeMpvOptions, mpv_args?: string[]);

    /**
     * Loads a file into MPV
     *
     * @param source - Path to the media file
     * @param mode
     * `replace`: replace the current media
     *
     * `append`: Append at the end of the playlist
     *
     * `append-play`: Append after the current song
     * @param options - Options formatted as option=label
     */
    load(source: string, mode?: MediaLoadMode, options?: string[]): Promise<void>;

    // https://github.com/j-holub/Node-MPV/blob/master/lib/mpv/_audio.js
    /**
     * Add an audio track to the media file
     *
     * @param file - Path to the audio track
     * @param flag - Flag to use (select, auto, cached)
     * @param title - Title in OSD/OSC
     * @param lang - Language
     */
    addAudioTrack(file: string, flag?: AudioFlag, title?: string, lang?: string): Promise<void>;

    /**
     * Remove an audio track based on its id.
     *
     * @param id - ID of the audio track to remove
     */
    removeAudioTrack(id: number): Promise<void>;

    /**
     * Select an audio track based on its id.
     *
     * @param id - ID of the audio track to select
     */
    selectAudioTrack(id: number): Promise<void>;

    /**
     * Cycles through the audio track
     */
    cycleAudioTracks(): Promise<void>;

    /**
     * Adjust audio timing
     * @param seconds - Delay in seconds
     */
    adjustAudioTiming(seconds: number): Promise<void>;

    /**
     * Set playback speed
     * @param factor - 0.1 - 100: percentage of playback speed
     */
    speed(factor: number): Promise<void>;

    // https://github.com/j-holub/Node-MPV/blob/master/lib/mpv/_controls.js
    /**
     * Toggle play/pause
     */
    togglePause(): Promise<void>;

    /**
     * Pauses playback
     */
    pause(): Promise<void>;

    /**
     * Resumes playback
     */
    resume(): Promise<void>;

    /**
     * Play the file in playlist
     */
    play(): Promise<void>;

    /**
     * Stop playback immediately
     */
    stop(): Promise<void>;

    /**
     * Set volume
     *
     * @param volume
     */
    volume(volume: number): Promise<void>;

    /**
     * Increase/Decrease volume
     *
     * @param volume
     */
    adjustVolume(volume: number): Promise<void>;

    /**
     * Mute
     *
     * @param set - setMute, if not specified, cycles
     */
    mute(set?: boolean): Promise<void>;

    /**
     * Seek
     *
     * @param seconds - Seconds
     * @param mode - Relative, absolute
     * @see for info about seek https://mpv.io/manual/stable/#command-interface-seek-%3Ctarget%3E-[%3Cflags%3E]
     */
    seek(seconds: number, mode?: SeekMode): Promise<void>;

    /**
     * Shorthand for absolute seek
     *
     * @param seconds - Seconds
     */
    goToPosition(seconds: number): Promise<void>;

    /**
     * Set loop mode for current file
     *
     * @param times - either a number of loop iterations, 'inf' for infinite loop or 'no' to disable loop.
     * If it's not specified, the property will cycle through inf and no.
     */
    loop(times?: RepeatMode): Promise<void>;

    // https://github.com/j-holub/Node-MPV/blob/master/lib/mpv/_commands.js
    // List of mpv properties are available here: https://mpv.io/manual/stable/#property-list
    /**
     * Retrieve a property
     *
     * @param property
     */
    getProperty(property: string): Promise<string>;

    /**
     * Set a property
     *
     * @param property
     * @param value
     */
    setProperty(property: string, value: any): Promise<void>;

    /**
     * Set a set of properties
     *
     * @param properties - {property1: value1, property2: value2}
     */
    setMultipleProperties(properties: object): Promise<void>;

    /**
     * Add value to a property (only on number properties)
     *
     * @param property
     * @param value
     */
    addProperty(property: string, value: number): Promise<void>;
    /**
     * Multiply a property by value (only on number properties)
     *
     * @param property
     * @param value
     */
    multiplyProperty(property: string, value: number): Promise<void>;

    /**
     * Cycle through different modes of a property (boolean, enum)
     *
     * @param property
     */
    cycleProperty(property: string): Promise<void>;

    /**
     * Send a custom command to mpv
     *
     * @param command Command name
     * @param args Array of arguments
     */
    command(command: string, args: string[]): Promise<void>;

    /**
     * Send a custom payload to mpv
     *
     * @param command the JSON command to send to mpv
     */
    commandJSON(command: object): Promise<void>;

    /**
     * Send a custom payload to mpv (no JSON encode)
     *
     * @param command the JSON encoded command to send to mpv
     */
    freeCommand(command: string): Promise<void>;

    /**
     * Observe a property
     * You can receive events with the 'status' event
     *
     * @param property The property to observe
     */
    observeProperty(property: string): any;

    /**
     * Unobserve a property
     *
     * @param property
     */
    unobserveProperty(property: string): any;

    // https://github.com/j-holub/Node-MPV/blob/master/lib/mpv/_information.js
    /**
     * Returns the mute status of mpv
     */
    isMuted(): Promise<boolean>;

    /**
     * Returns the pause status of mpv
     */
    isPaused(): Promise<boolean>;

    /**
     * Returns the seekable property of the loaded media
     * Some medias are not seekable (livestream, unbuffered media)
     */
    isSeekable(): Promise<boolean>;

    /**
     * Retrieve the duration of the loaded media
     */
    getDuration(): Promise<number>;

    /**
     * Retrieve the current time position of the loaded media
     */
    getTimePosition(): Promise<number>;

    /**
     * Retrieve the current time position (in percentage) of the loaded media
     */
    getPercentPosition(): Promise<number>;

    /**
     * Retrieve the time remaining of the loaded media
     */
    getTimeRemaining(): Promise<number>;

    /**
     * Retrieve the metadata of the loaded media
     */
    getMetadata(): Promise<object>;

    /**
     * Retrieve the title of the loaded media
     */
    getTitle(): Promise<string>;

    /**
     * Retrieve the artist of the loaded media
     */
    getArtist(): Promise<string>;

    /**
     * Retrieve the album of the loaded media
     */
    getAlbum(): Promise<string>;

    /**
     * Retrieve the year of the loaded media
     */
    getYear(): Promise<number>;

    /**
     * Retrieve the filename of the loaded media
     *
     * @param format 'stripped' remove the extension, default to 'full'
     */
    getFilename(format?: "full" | "stripped"): Promise<string>;

    // https://github.com/j-holub/Node-MPV/blob/master/lib/mpv/_playlist.js
    /**
     * Load a playlist file
     *
     * @param playlist Path to the playlist file
     * @param mode 'append' adds the playlist to the existing one. Defaults to 'replace'
     */
    loadPlaylist(playlist: string, mode?: LoadMode): Promise<void>;

    /**
     * Add a song to the playlist
     *
     * @param source File path of media
     * @param mode
     * replace: replace the current media
     * append: Append at the end of the playlist
     * append-play: Append after the current song
     * @param options
     */
    append(source: string, mode?: MediaLoadMode, options?: string[]): Promise<void>;

    /**
     * Load next element in playlist
     *
     * @param mode - 'force' may go into an undefined index of the playlist
     */
    next(mode?: PlaylistMode): Promise<void>;

    /**
     * Load previous element in playlist
     *
     * @param mode - 'force' may go into an undefined index of the playlist
     */
    prev(mode?: PlaylistMode): Promise<void>;

    /**
     * Jump to position in playlist
     *
     * @param position
     */
    jump(position: number): Promise<void>;

    /**
     * Empty the playlist
     */
    clearPlaylist(): Promise<void>;

    /**
     *
     * @param index
     */
    playlistRemove(index: number): Promise<void>;

    /**
     *
     * @param index1
     * @param index2
     */
    playlistMove(index1: number, index2: number): Promise<void>;

    /**
     *
     */
    shuffle(): Promise<void>;

    /**
     *
     */
    getPlaylistSize(): Promise<number>;

    /**
     *
     */
    getPlaylistPosition(): Promise<number>;

    /**
     *
     */
    getPlaylistPosition1(): Promise<number>;

    /**
     * Set loop mode for playlist
     *
     * @param times - either a number of loop iterations, 'inf' for infinite loop or 'no' to disable loop.
     * If it's not specified, the property will cycle through inf and no.
     */
    loopPlaylist(times?: RepeatMode): Promise<void>;

    // https://github.com/j-holub/Node-MPV/blob/master/lib/mpv/_startStop.js
    /**
     * Starts mpv, by spawning a child process or by attaching to existing socket
     */
    start(): Promise<void>;
    /**
     * Closes mpv
     *
     * [Important!] Calling method `quit` doesn't trigger the event `quit`
     */
    quit(): Promise<void>;
    /**
     * Returns the status of mpv
     */
    isRunning(): boolean;

    // https://github.com/j-holub/Node-MPV/blob/master/lib/mpv/_subtitle.js
    /**
     * Loads a subtitle file into the current media file
     *
     * @param file Path to the subtitle file
     * @param flag
     * Select: Select the loaded file
     * Auto: Let mpv decide
     * Cached: Don't select the loaded file
     * @param title Title to show in OSD/OSC
     * @param lang Language of the subtitles
     */
    addSubtitles(file: string, flag?: "select" | "auto" | "cached", title?: string, lang?: string): Promise<void>;

    /**
     * Remove subtitles
     *
     * @param id Index of subtitles to delete
     */
    removeSubtitles(id: number): Promise<void>;

    /**
     * Cycle through available subtitles
     */
    cycleSubtitles(): Promise<void>;

    /**
     * Select subtitles by its id
     *
     * @param id
     */
    selectSubtitles(id: number): Promise<void>;

    /**
     * Toggle subtitles visibility
     */
    toggleSubtitleVisibility(): Promise<void>;

    /**
     * Show the subtitles on the screen
     */
    showSubtitles(): Promise<void>;

    /**
     * Hide the subtitles on the screen
     */
    hideSubtitles(): Promise<void>;

    /**
     * Adjust the subtitles offset to seconds
     *
     * @param seconds Offset to apply in seconds
     */
    adjustSubtitleTiming(seconds: number): Promise<void>;

    /**
     * Seek based on subtitles lines
     *
     * @param lines
     */
    subtitleSeek(lines: number): Promise<void>;

    /**
     * Scale the font of subtitles based on scale
     *
     * @param scale
     */
    subtitleScale(scale: number): Promise<void>;

    /**
     * Show a text using ASS renderer
     *
     * @param ass an ass string
     * @param duration duration in seconds
     * @param position ASS alignment
     */
    displayASS(ass: string, duration: number, position?: number): Promise<void>;

    // https://github.com/j-holub/Node-MPV/blob/master/lib/mpv/_video.js
    /**
     * Enter fullscreen
     */
    fullscreen(): Promise<void>;

    /**
     * Leave fullscreen
     */
    leaveFullscreen(): Promise<void>;

    /**
     * Toggle fullscreen
     */
    toggleFullscreen(): Promise<void>;

    /**
     * Take a screenshot
     *
     * @param file
     * @param option
     * Subtitles: show subtitles
     * Video: hide subtitles/osd/osc
     * Window: Take the screen at the size of the window
     */
    screenshot(file: string, option: "subtitles" | "video" | "window"): Promise<void>;

    /**
     * Rotate the video
     *
     * @param degrees
     */
    rotateVideo(degrees: number): Promise<void>;

    /**
     * Zoom the video, 0 means no zoom, 1 means x2
     *
     * @param factor
     */
    zoomVideo(factor: number): Promise<void>;

    /**
     * Set Brightness
     *
     * @param value
     */
    brightness(value: number): Promise<void>;

    /**
     * Set Contrast
     *
     * @param value
     */
    contrast(value: number): Promise<void>;

    /**
     * Set saturation
     *
     * @param value
     */
    saturation(value: number): Promise<void>;

    /**
     * Set gamme on media
     *
     * @param value
     */
    gamma(value: number): Promise<void>;

    /**
     * Set Hue
     *
     * @param value
     */
    hue(value: number): Promise<void>;
  }
}
