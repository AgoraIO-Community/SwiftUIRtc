# SwiftUI Video Streaming

## Overview

SwiftUI has emerged as a game-changer in app development, providing a modern and intuitive way to build user interfaces for various Apple platforms. While SwiftUI offers tremendous capabilities, there is a noticeable absence of robust solutions for live streaming applications. However, the SwiftUIRtc package fills this gap by offering a seamless integration of live streaming capabilities in SwiftUI. In this article, we explore how SwiftUIRtc empowers developers to create compelling live streaming applications using the power of SwiftUI.

## The Challenge of Live Streaming in SwiftUI

Live streaming poses unique challenges in terms of real-time video rendering, media synchronization, and interactive features. SwiftUI, although a powerful UI framework, lacks native support for live streaming components. Developers often face the daunting task of integrating third-party libraries and complex workarounds using UIViewRespresentable over and over again to achieve live streaming functionality in their SwiftUI apps.

## A SwiftUI Live Streaming Solution

The package ``SwiftUIRtc`` is designed to address awkward workarounds needed for live streaming in SwiftUI. It provides a small set of tools and SwiftUI components that enable developers to effortlessly incorporate live streaming capabilities into their SwiftUI applications. By leveraging ``SwiftUIRtc``, developers can overcome the hurdles associated with live streaming integration and focus on delivering an exceptional streaming experience to their users.

The package uses the Agora Video RTC engine under the hood to ensure that the best network is used for this solution.

## Key Classes of SwiftUIRtc

Although the SwiftUIRtc package is relatively light by design, its limited classes and methods are everything developers need to start working with live streaming applications right away.

### AgoraManager

``AgoraManager`` has several very important responsibilities, including session management and connection handling. ``AgoraManager`` will keep track of the users who join and leave the channel so that you as the developer know what IDs you need to render the video for. These IDs are tracked using delegate methods from the Agora RTC engine which stores them in a published variable, ``AgoraManager/allUsers``.

Join and leave channel methods:

- ``AgoraManager/joinChannel(_:token:uid:info:)``
- ``AgoraManager/leaveChannel(leaveChannelBlock:destroyEngine:)``

Implemented delegate methods:

- ``AgoraManager/rtcEngine(_:didJoinedOfUid:elapsed:)``
- ``AgoraManager/rtcEngine(_:didOfflineOfUid:reason:)``

### AgoraVideoCanvasView

``AgoraVideoCanvasView`` is a UIViewRepresentable struct that provides a view for displaying remote or local video in an Agora RTC session. With access to the engine through ``AgoraManager``, ``AgoraVideoCanvasView`` displays local and remote video streams when provided with just a desired ID.

## Example

Using just the two classes described above, we can easily add an AgoraManager that keeps track of all the users in the scene and an AgoraVideoCanvasView for each user listed in the allUsers property as follows:

```swift
import SwiftUIRtc
import AgoraRtcKit

struct ScrollingVideoCallView: View {
    @ObservedObject var agoraManager = AgoraManager(appId: <#AppId#>, role: .broadcaster)
    var channelId: String = "test"
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(agoraManager.allUsers), id: \.self) { uid in
                    AgoraVideoCanvasView(manager: agoraManager, canvasId: .userId(uid))
                        .aspectRatio(contentMode: .fit).cornerRadius(10)
                }
            }.padding(20)
        }.onAppear {
            agoraManager.joinChannel(channelId, token: <#Agora Temp Token#>)
        }.onDisappear {
            agoraManager.leaveChannel()
        }
    }
}
```

When displayed in a ScrollView as above, the different video feeds will automatically appear in a scrolling list view, scaling to however many users join the channel.

@Video(source: scrolling_videos_view.mov, poster: scrolling_videos_view.gif)

As this library matures, more example usage will be linked from here.

## Extending SwiftUIRtc

All of the methods in AgoraManager and AgoraVideoCanvasView are marked as `open`, and the library is open source. That means that each of these classes can be extended with subclasses to add functionality tailored to the exact needs of any SwiftUI application.

For example, if you need to record the quality of incoming streams, you can subclass AgoraManager as follows:

```swift
public class CallQualityManager: AgoraManager {
    /// A dictionary mapping user IDs to call quality statistics.
    @Published public var callQualities: [UInt: String] = [:]
}
```

And add a couple of additional delegate methods:

```swift
extension CallQualityManager {
    public func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        self.callQualities[stats.uid] = """
        Received Bitrate = \(stats.receivedBitrate)
        Frame = \(stats.width)x\(stats.height), \(stats.receivedFrameRate)fps
        Frame Loss Rate = \(stats.frameLossRate)
        Packet Loss Rate = \(stats.packetLossRate)
        """
    }

    public func rtcEngine(_ engine: AgoraRtcEngineKit, localVideoStats stats: AgoraRtcLocalVideoStats, sourceType: AgoraVideoSourceType) {
        self.callQualities[self.localUserId] = """
        Captured Frame = \(stats.captureFrameWidth)x\(stats.captureFrameHeight), \(stats.captureFrameRate)fps
        Encoded Frame = \(stats.encodedFrameWidth)x\(stats.encodedFrameHeight), \(stats.encoderOutputFrameRate)fps
        Sent Data = \(stats.sentFrameRate)fps, bitrate: \(stats.sentBitrate)
        Packet Loss Rate = \(stats.txPacketLossRate)
        """
    }
}
```

To display those call quality data, a simple change to ScrollingVideoCallView (above) adds an overlay to each ``AgoraVideoCanvasView``:

```swift
AgoraVideoCanvasView(manager: agoraManager, canvasId: .userId(uid))
    .aspectRatio(contentMode: .fit).cornerRadius(10)
    .overlay(alignment: .topLeading) {
        Text(agoraManager.callQualities[uid] ?? "no data").padding()
    }
```

@Image(source: scrolling_quality_view.jpeg)

## Conclusion

SwiftUIRtc brings simplicity and ease of use to the process of integrating live streaming capabilities into SwiftUI applications. By leveraging AgoraManager and AgoraVideoCanvasView, you can add video streams through the Agora RTC SDK, without having to deal with non-SwiftUI classes.

Use SwiftUIRtc in your iOS applications today by adding the package with:

```txt
https://github.com/AgoraIO-Community/SwiftUIRtc.git
```
