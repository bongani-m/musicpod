import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../app/app_model.dart';
import '../../app/connectivity_model.dart';
import '../../common/data/audio_type.dart';
import '../../common/view/icons.dart';
import '../../common/view/theme.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/build_context_x.dart';
import '../../extensions/taget_platform_x.dart';
import '../../l10n/l10n.dart';
import '../../player/player_model.dart';
import 'bottom_player_image.dart';
import 'bottom_player_like_and_star_button.dart';
import 'play_button.dart';
import 'playback_rate_button.dart';
import 'player_color.dart';
import 'player_main_controls.dart';
import 'player_pause_timer_button.dart';
import 'player_title_and_artist.dart';
import 'player_track.dart';
import 'player_view.dart';
import 'queue/queue_button.dart';
import 'volume_popup.dart';

class BottomPlayer extends StatelessWidget with WatchItMixin {
  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final smallWindow = context.smallWindow;
    final audio = watchPropertyValue((PlayerModel m) => m.audio);
    final isVideo = watchPropertyValue((PlayerModel m) => m.isVideo);

    final model = di<PlayerModel>();
    final appModel = di<AppModel>();
    final isOnline = watchPropertyValue((ConnectivityModel m) => m.isOnline);

    final active = audio?.path != null || isOnline;

    final trackAndPlayer = [
      PlayerTrack(active: active, bottomPlayer: true),
      InkWell(
        onTap: () => appModel.setFullWindowMode(true),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: kLargestSpace),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: BottomPlayerImage(
                    audio: audio,
                    size: bottomPlayerDefaultHeight - 24,
                    videoController: model.controller,
                    isVideo: isVideo,
                    isOnline: isOnline,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    const Flexible(
                      flex: 5,
                      child: PlayerTitleAndArtist(
                        playerPosition: PlayerPosition.bottom,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (!smallWindow)
                      BottomPlayerLikeAndStarButton(audio: audio),
                  ],
                ),
              ),
              if (!smallWindow)
                Expanded(flex: 6, child: PlayerMainControls(active: active)),
              if (!smallWindow)
                Flexible(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (audio?.audioType == AudioType.podcast)
                        PlaybackRateButton(active: active),
                      if (!isMobile) const VolumeSliderPopup(),
                      const PlayerPauseTimerButton(),
                      const QueueButton(isSelected: false),
                      IconButton(
                        tooltip: context.l10n.fullWindow,
                        icon: Icon(
                          Iconz.fullWindow,
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () => appModel.setFullWindowMode(true),
                      ),
                    ],
                  ),
                )
              else ...[
                BottomPlayerLikeAndStarButton(audio: audio),
                const SizedBox(width: 10),
                PlayButton(active: active),
              ],
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    ];

    final player = SizedBox(
      height: bottomPlayerDefaultHeight,
      child: Column(
        children: (isMobile ? trackAndPlayer.reversed : trackAndPlayer)
            .toList(),
      ),
    );

    if (isVideo == true) {
      return player;
    }

    return Stack(
      children: [
        if (!isMobile)
          PlayerColor(
            position: PlayerPosition.bottom,
            alpha: 0.2,
            size: Size(double.infinity, bottomPlayerDefaultHeight),
          ),
        player,
      ],
    );
  }
}
