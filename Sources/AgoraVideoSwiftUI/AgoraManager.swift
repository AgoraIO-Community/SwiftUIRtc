//
//  AgoraManager.swift
//  
//
//  Created by Max Cobb on 24/03/2023.
//

import Foundation
import AgoraRtcKit

/**
``AgoraManager`` is a class that provides an interface to the Agora RTC Engine Kit. It conforms to the `ObservableObject` and `AgoraRtcEngineDelegate` protocols.

Use AgoraManager to set up and manage Agora RTC sessions, manage the client's role, and control the client's connection to the Agora RTC server.
*/
open class AgoraManager: NSObject, ObservableObject, AgoraRtcEngineDelegate {
    /// The Agora App ID for the session.
    public let appId: String
    /// The client's role in the session.
    public var role: AgoraClientRole = .audience {
        didSet { engine.setClientRole(role) }
    }
    /// The Agora RTC Engine Kit for the session.
    public var engine: AgoraRtcEngineKit {
        let eng = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        eng.enableVideo()
        eng.setClientRole(role)
        return eng
    }

    /**
     Initializes a new instance of `AgoraManager` with the specified app ID and client role.

     - Parameters:
        - appId: The Agora App ID for the session.
        - role: The client's role in the session. The default value is `.audience`.
     */
    public init(appId: String, role: AgoraClientRole = .audience) {
        self.appId = appId
        self.role = role
    }

    /**
     Leaves the channel and stops the preview for the session.

     - Parameter leaveChannelBlock: An optional closure that will be called when the client leaves the channel. The closure takes an `AgoraChannelStats` object as its parameter.
     */
    open func leaveChannel(leaveChannelBlock: ((AgoraChannelStats) -> Void)? = nil) {
        self.engine.leaveChannel(leaveChannelBlock)
        self.engine.stopPreview()
        AgoraRtcEngineKit.destroy()
    }
}

