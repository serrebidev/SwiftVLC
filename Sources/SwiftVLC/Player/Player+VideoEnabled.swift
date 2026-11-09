import CLibVLC

extension Player {
  /// Stops or resumes video decoding for the current media by unselecting or
  /// reselecting its video track. Audio keeps playing.
  ///
  /// Accessible IPTV uses this to stop decoding video while the app is in the
  /// background. Patch carried on the serrebi/SwiftVLC `accessible-iptv` branch.
  public func setVideoEnabled(_ enabled: Bool) {
    guard nativeHandleRepresentsCurrentMedia else { return }
    if enabled {
      guard let track = videoTracks.first(where: \.isSelected) ?? videoTracks.first,
            let cTrack = libvlc_media_player_get_track_from_id(pointer, track.id)
      else { return }
      libvlc_media_player_select_track(pointer, cTrack)
      libvlc_media_track_release(cTrack)
    } else {
      libvlc_media_player_unselect_track_type(pointer, libvlc_track_video)
    }
  }
}
