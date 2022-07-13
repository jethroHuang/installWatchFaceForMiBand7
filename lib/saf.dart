/// Convert Directory path to URI String
String makeUriString({String path = "", bool isTreeUri = false}) {
  String uri = "";
  String base =
      "content://com.android.externalstorage.documents/tree/primary%3A";
  String documentUri = "/document/primary%3A" +
      path.replaceAll("/", "%2F").replaceAll(" ", "%20");
  if (isTreeUri) {
    uri = base + path.replaceAll("/", "%2F").replaceAll(" ", "%20");
  } else {
    var pathSegments = path.split("/");
    var fileName = pathSegments[pathSegments.length - 1];
    var directory = path.split("/$fileName")[0];
    uri = base +
        directory.replaceAll("/", "%2F").replaceAll(" ", "%20") +
        documentUri;
  }
  return uri;
}

String makeTreeUriString(String path) {
  return makeUriString(path: path, isTreeUri: true);
}


/// Convert URI String into Directory path
String makeDirectoryPath(String uriString) {
  String directoryPathUriString = uriString.split("primary%3A")[1];
  String directoryPath =
  directoryPathUriString.replaceAll("%2F", "/").replaceAll("%20", " ");
  return directoryPath;
}

/// Create a name Alias for Directory path e.g. Android/media/matrix -> Android_media_matrix
String makeDirectoryPathToName(String path) {
  return path.replaceAll("/", "_");
}