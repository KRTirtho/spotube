#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  desktop_webview_window
  file_selector_linux
  flutter_secure_storage_linux
  gtk
  local_notifier
  media_kit_libs_linux
  screen_retriever
  sqlite3_flutter_libs
  system_theme
  tray_manager
  url_launcher_linux
  window_manager
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
  flutter_discord_rpc
  media_kit_native_event_loop
  metadata_god
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/linux plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/linux plugins/${ffi_plugin})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
endforeach(ffi_plugin)
