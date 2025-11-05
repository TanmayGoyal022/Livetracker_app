#include "core.h"

namespace firebase_core {

void InitializeFirebase() {
  // Initialize Firebase for Windows
  firebase::AppOptions options;
  // NOTE: Replace the WINDOWS appId below if you have a platform-specific Windows App ID.
  // Using the project-level values provided. If you register a Windows app in the
  // Firebase Console, put that app's appId here (format: 1:PROJECT_NUMBER:windows:...)
  options.set_app_id("1:757144083751:windows:REPLACE_WITH_WINDOWS_APP_ID");
  options.set_api_key("AIzaSyCCqLX9VLROYj3nSL6ldyArFhqMFeew2Nc");
  options.set_project_id("livetrackingapp-f881e");
  options.set_storage_bucket("livetrackingapp-f881e.appspot.com");

  firebase::App::Create(options);
}
}