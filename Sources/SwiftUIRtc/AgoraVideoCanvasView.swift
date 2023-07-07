//
//  AgoraVideoCanvasView.swift
//  
//
//  Created by Max Cobb on 24/03/2023.
//

import SwiftUI
#if os(iOS)
public typealias ViewClassAlias = UIView
public typealias ViewRepAlias = UIViewRepresentable
#elseif os(macOS)
public typealias ViewClassAlias = NSView
public typealias ViewRepAlias = NSViewRepresentable
#endif
import AgoraRtcKit

/// 🎥 AgoraRtcVideoCanvas must have the `ObservableObject` protocol applied,
/// so it can be a `@StateObject` for ``AgoraVideoCanvasView``.
extension AgoraRtcVideoCanvas: ObservableObject {}

/// 🖼️ This protocol lets ``AgoraVideoCanvasView`` fetch the information it needs,
/// while avoiding a strong dependency on ``AgoraManager``.
public protocol CanvasViewHelper: AnyObject {
    /// 📞 Instance of the Agora RTC Engine
    var agoraEngine: AgoraRtcEngineKit! { get }
    /// 🆔 Id of the local user in the channel.
    var localUserId: UInt { get }
}

/// Add the ``CanvasViewHelper`` protocol to ``AgoraManager``.
extension AgoraManager: CanvasViewHelper {}

/// 🎞️ AgoraVideoCanvasView is a SwiftUI view that displays remote or local video in an Agora RTC session.
///
/// Use AgoraVideoCanvasView to create a view that displays the video stream from a remote user or the local user's camera in an Agora RTC session.
/// You can specify the render mode, crop area, and setup mode for the view.
public struct AgoraVideoCanvasView: ViewRepAlias {
    /// 🎥 The `AgoraRtcVideoCanvas` object that represents the video canvas for the view.
    @StateObject private var canvas = AgoraRtcVideoCanvas()

    /// 🔄 Reference to a protocol ``CanvasViewHelper`` that helps with fetching the engine instance, as well as the local user's ID.
    /// ``AgoraManager`` conforms to this protocol.
    public weak var manager: CanvasViewHelper?
    /// 🆔 The user ID of the remote user whose video to display, or `0` to display the local user's video.
    public let uid: UInt

    /// 🎨 The render mode for the view.
    public var renderMode: AgoraVideoRenderMode = .hidden

    /// 🖼️ The crop area for the view.
    public var cropArea: CGRect = .zero

    /// 🔧 The setup mode for the view.
    public var setupMode: AgoraVideoViewSetupMode = .replace

    /// Create a new AgoraRtcVideoCanvas for displaying a remote or local video stream in a SwiftUI view.
    ///
    /// - Parameters:
    ///    - manager: An instance of an object that conforms to ``CanvasViewHelper``, such as ``AgoraManager``.
    ///    - uid: The user ID for the video stream.
    ///    - renderMode: The render mode for the video stream, which determines how the video is scaled and displayed.
    ///    - cropArea: The portion of the video stream to display, specified as a CGRect with values between 0 and 1.
    ///    - setupMode: The mode for setting up the video view, which determines whether to replace or merge with existing views.
    ///
    /// - Returns: An AgoraVideoCanvasView instance, which can be added to a SwiftUI view hierarchy.
    public init(
        manager: CanvasViewHelper, uid: UInt,
        renderMode: AgoraVideoRenderMode = .hidden,
        cropArea: CGRect = .zero,
        setupMode: AgoraVideoViewSetupMode = .replace
    ) {
        self.manager = manager
        self.uid = uid
        self.renderMode = renderMode
        self.cropArea = cropArea
        self.setupMode = setupMode
    }

    fileprivate init(uid: UInt) {
        self.uid = uid
    }
    #if os(macOS)
    /// Creates and configures an `NSView` for the view. This NSView will be the view the video is rendered onto.
    ///
    /// - Parameter context: The `NSViewRepresentable` context.
    ///
    /// - Returns: An `NSView` for displaying the video stream.
    public func makeNSView(context: Context) -> ViewClassAlias {
        setupCanvasView()
    }
    #elseif os(iOS)
    /// Creates and configures a `UIView` for the view. This UIView will be the view the video is rendered onto.
    ///
    /// - Parameter context: The `UIViewRepresentable` context.
    ///
    /// - Returns: A `UIView` for displaying the video stream.
    public func makeUIView(context: Context) -> ViewClassAlias {
        setupCanvasView()
    }
    #endif
    private func setupCanvasView() -> ViewClassAlias {
        // Create and return the remote video view
        let canvasView = ViewClassAlias()
        canvas.view = canvasView
        canvas.renderMode = renderMode
        canvas.cropArea = cropArea
        canvas.setupMode = setupMode
        canvas.uid = uid
        canvasView.isHidden = false
        if uid == manager?.localUserId {
            // Start the local video preview
            manager?.agoraEngine.startPreview()
            manager?.agoraEngine.setupLocalVideo(canvas)
        } else {
            manager?.agoraEngine.setupRemoteVideo(canvas)
        }
        return canvasView
    }

    /// Updates the `AgoraRtcVideoCanvas` object for the view with new values, if necessary.
    private func updateCanvasValues() {
        guard canvas.renderMode != renderMode ||
                canvas.cropArea != cropArea ||
                canvas.setupMode != setupMode ||
                canvas.uid != uid
        else { return }
        // Update the canvas properties if needed
        canvas.renderMode = renderMode
        canvas.cropArea = cropArea
        canvas.setupMode = setupMode

        if canvas.uid == uid { return }
        canvas.uid = uid
        if uid == manager?.localUserId {
            manager?.agoraEngine.setupLocalVideo(canvas)
        } else {
            manager?.agoraEngine.setupRemoteVideo(canvas)
        }
    }

    /// Updates the Canvas view.
    #if os(iOS)
    public func updateUIView(_ uiView: ViewClassAlias, context: Context) {
        self.updateCanvasValues()
    }
    #elseif os(macOS)
    public func updateNSView(_ nsView: ViewClassAlias, context: Context) {
        self.updateCanvasValues()
    }
    #endif
}

struct AgoraVideoCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        AgoraVideoCanvasView(uid: 0)
    }
}
