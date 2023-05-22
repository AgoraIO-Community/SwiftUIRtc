# ``SwiftUIRtc``

SwiftUIRtc is a package for building video call apps using the Agora RTC SDK and SwiftUI. It provides a set of SwiftUI views and classes that simplify setting up and managing Agora RTC sessions for video calls.

## Overview

Use the classes in this package to build a SwiftUI app that adds Real-time Communication in a SwiftUI-friendly way.

## Example

Here's a simple implementation of SwiftUIRtc, where all the streaming users will display in a vertically scrolling view:

```swift
import SwiftUIRtc
import AgoraRtcKit

struct AgoraGettingStartedView: View {
    @ObservedObject var agoraManager = AgoraManager(appId: <#AppId#>, role: .broadcaster)
    var body: some View {
        ScrollView { VStack {
            ForEach(Array(agoraManager.allUsers), id: \.self) { uid in
                AgoraVideoCanvasView(agoraKit: agoraManager.engine, uid: uid)
                    .aspectRatio(contentMode: .fit).cornerRadius(10)
            }
        }.padding(20) }
        .onAppear { agoraManager.joinChannel("test") }
        .onDisappear { agoraManager.leaveChannel() }
    }
}
```

## Topics

### Articles

- <doc:SwiftUI-Video-Streaming>

### Core Classes

- ``AgoraManager``
- ``AgoraVideoCanvasView``
