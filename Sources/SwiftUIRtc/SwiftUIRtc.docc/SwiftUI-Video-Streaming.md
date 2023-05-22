# SwiftUI Video Streaming

## Overview

SwiftUI has emerged as a game-changer in app development, providing a modern and intuitive way to build user interfaces for various Apple platforms. While SwiftUI offers tremendous capabilities, there has been a noticeable absence of robust solutions for live streaming applications. However, the SwiftUIRtc package fills this gap by offering a seamless integration of live streaming capabilities within SwiftUI. In this article, we will explore how SwiftUIRtc empowers developers to create compelling live streaming applications using the power of SwiftUI.

## The Challenge of Live Streaming in SwiftUI

Live streaming poses unique challenges in terms of real-time video rendering, media synchronization, and interactive features. SwiftUI, although a powerful UI framework, lacks native support for live streaming components. Developers often face the daunting task of integrating third-party libraries and complex workarounds using UIViewRespresentable over and over again to achieve live streaming functionality within their SwiftUI apps.

## A SwiftUI Live Streaming Solution

The package `SwiftUIRtc` is designed to address awkward workarounds needed for live streaming in SwiftUI. It provides a small set of tools and SwiftUI components that enable developers to effortlessly incorporate live streaming capabilities into their SwiftUI applications. By leveraging ``SwiftUIRtc``, developers can overcome the hurdles associated with live streaming integration and focus on delivering an exceptional streaming experience to their users.

The package itself uses Agora's Video RTC engine under the hood, to make sure that the best network is used for this solution.

## Key Classes of SwiftUIRtc

Although the package is relatively light by design, its limit classes and methods are everything developers need to start working with live streaming applications right away.

### AgoraManager

``AgoraManager`` has several very important responsibilities, such as session management and connection handling. AgoraManager will keep track of the users who join and leave the channel, so that you as the developer know what IDs you need to render the video for. These IDs are tracked using delegate methods from Agora's RTC Engine, and stores them in a published variable, ``AgoraManager/allUsers``.

Join and Leave Channel Methods:

- ``AgoraManager/joinChannel(_:token:uid:info:)``
- ``AgoraManager/leaveChannel(leaveChannelBlock:)``

Implemented Delegate Methods:

- ``AgoraManager/rtcEngine(_:didJoinedOfUid:elapsed:)``
- ``AgoraManager/rtcEngine(_:didOfflineOfUid:reason:)``

### AgoraVideoCanvasView

``AgoraVideoCanvasView`` is a UIViewRepresentable struct that provides a view for displaying remote or local video in an Agora RTC session. With access to the engine through ``AgoraManager``, it displays local and remote video streams when provided just a desired ID.

## Example

Using just the two classes described above, we can easily add an AgoraManager that keeps track of all the users in the scene, and an AgoraVideoCanvasView for each user listed in the allUsers property as such: 

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
                    AgoraVideoCanvasView(agoraKit: agoraManager.engine, uid: uid)
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

When displayed in a ScrollView like above, the different video feeds will just appear in a scrolling list view automatically, scaling to however many users join the channel.

As this library matures, more example usage will be linked from here.

## Extending SwiftUIRtc

All of the methods in AgoraManager and AgoraVideoCanvasView are marked as `open`, and the library is of course open source. That means that each of these classes can be extended with subclasses to add functionality tailored to the exact needs of any SwiftUI application.

## Conclusion

SwiftUIRtc brings simplicity and ease to the process of integrating live streaming capabilities to SwiftUI Applications. By leveraging AgoraManager and AgoraVideoCanvasView, you can add video streams through Agora's RTC SDK, without having to deal with non-SwiftUI classes.

Use SwiftUIRtc in your iOS applications today by adding the package with:

```txt
https://github.com/AgoraIO-Community/SwiftUIRtc.git
```
