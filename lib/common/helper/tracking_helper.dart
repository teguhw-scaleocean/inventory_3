class TrackingHelper {
  int getTrackingId(String tracking) {
    int idTracking = 0;
    String tracking0 = "";
    tracking0 = tracking;

    switch (tracking0) {
      case "Serial Number":
        idTracking = 0;
        break;
      case "Lots":
        idTracking = 1;
        break;
      case "No Tracking":
        idTracking = 2;
        break;
      default:
    }
    return idTracking;
  }
}
