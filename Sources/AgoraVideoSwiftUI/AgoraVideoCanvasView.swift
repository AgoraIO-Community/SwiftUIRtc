//
//  SwiftUIView.swift
//  
//
//  Created by Max Cobb on 24/03/2023.
//

import SwiftUI
import AgoraRtcKit

extension AgoraRtcVideoCanvas: ObservableObject {
    /// This could be used instead of UIView directly, if the canvas view also needs to retain its state in SwiftUI
//    class CanvasView: UIView, ObservableObject {}
}

/**
AgoraVideoCanvasView is a UIViewRepresentable struct that provides a view for displaying remote or local video in an Agora RTC session.

Use AgoraVideoCanvasView to create a view that displays the video stream from a remote user or the local user's camera in an Agora RTC session. You can specify the render mode, crop area, and setup mode for the view.
*/
public struct AgoraVideoCanvasView: UIViewRepresentable {
    /// The `AgoraRtcVideoCanvas` object that represents the video canvas for the view.
    @StateObject var canvas = AgoraRtcVideoCanvas()

    /// A weak reference to the `AgoraRtcEngineKit` object for the session.
    public weak var agoraKit: AgoraRtcEngineKit?

    /// The user ID of the remote user whose video to display, or `0` to display the local user's video.
    public let uid: UInt

    /// The render mode for the view.
    public var renderMode: AgoraVideoRenderMode = .hidden

    /// The crop area for the view.
    public var cropArea: CGRect = .zero

    /// The setup mode for the view.
    public var setupMode: AgoraVideoViewSetupMode = .replace

    /**
     A UIViewRepresentable wrapper for an AgoraRtcVideoCanvas, which can be used to display a remote or local video stream in a SwiftUI view.

     - Parameters:
        - agoraKit: An instance of the AgoraRtcEngineKit, which manages the video stream.
        - uid: The user ID for the video stream.
        - renderMode: The render mode for the video stream, which determines how the video is scaled and displayed.
        - cropArea: The portion of the video stream to display, specified as a CGRect with values between 0 and 1.
        - setupMode: The mode for setting up the video view, which determines whether to replace or merge with existing views.

     - Returns: An AgoraVideoCanvasView instance, which can be added to a SwiftUI view hierarchy.
    */
    public init(
        agoraKit: AgoraRtcEngineKit, uid: UInt,
        renderMode: AgoraVideoRenderMode = .hidden,
        cropArea: CGRect = .zero,
        setupMode: AgoraVideoViewSetupMode = .replace
    ) {
        self.agoraKit = agoraKit
        self.uid = uid
        self.renderMode = renderMode
        self.cropArea = cropArea
        self.setupMode = setupMode
    }

    fileprivate init(uid: UInt) {
        self.uid = uid
    }
    /**
     Creates and configures a `UIView` for the view. This UIView will be the view the video is rendered onto.

     - Parameter context: The `UIViewRepresentable` context.

     - Returns: A `UIView` for displaying the video stream.
     */
    public func makeUIView(context: Context) -> UIView {
        // Create and return the remote video view
        let canvasView = UIView()
        canvas.view = canvasView
        canvas.renderMode = renderMode
        canvas.cropArea = cropArea
        canvas.setupMode = setupMode
        canvas.uid = uid
        canvasView.isHidden = false
        if self.uid == 0 {
            // Start the local video preview
            agoraKit?.startPreview()
            agoraKit?.setupLocalVideo(canvas)
        } else {
            agoraKit?.setupRemoteVideo(canvas)
        }
        return canvasView
    }

    /**
     Updates the `AgoraRtcVideoCanvas` object for the view with new values, if necessary.
     */
    func updateCanvasValues() {
        if canvas.renderMode == renderMode, canvas.cropArea == cropArea, canvas.setupMode == setupMode {
            return
        }
        // Update the canvas properties if needed
        if canvas.renderMode != renderMode { canvas.renderMode = renderMode }
        if canvas.cropArea != cropArea { canvas.cropArea = cropArea }
        if canvas.setupMode != setupMode { canvas.setupMode = setupMode }

        if self.uid == 0 { agoraKit?.setupLocalVideo(canvas)
        } else { agoraKit?.setupRemoteVideo(canvas) }
    }

    /**
     Updates the `UIView` for the view.
    */
    public func updateUIView(_ uiView: UIView, context: Context) {
        self.updateCanvasValues()
    }
}

struct AgoraVideoCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        AgoraVideoCanvasView(uid: 0)
    }
}
