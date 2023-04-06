//
//  TouchHandlingView.swift
//  OpenParsec
//
//  Created by Seçkin KÜKRER on 6.04.2023.
//

import SwiftUI
import ParsecSDK

struct TouchHandlingView: UIViewRepresentable {
    let handleTouch: (ParsecMouseButton, CGPoint, UIGestureRecognizer.State) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isMultipleTouchEnabled = true
        view.isUserInteractionEnabled = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePanGesture(_:)))
        panGestureRecognizer.delegate = context.coordinator
        view.addGestureRecognizer(panGestureRecognizer)
        
        // Add tap gesture recognizer for two-finger touch
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTwoFingerTap(_:)))
        tapGestureRecognizer.numberOfTouchesRequired = 2
        view.addGestureRecognizer(tapGestureRecognizer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: TouchHandlingView

        init(_ parent: TouchHandlingView) {
            self.parent = parent
            super.init()
        }

        @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            parent.handleTouch(ParsecMouseButton(rawValue: 1), location, gestureRecognizer.state)
        }
        
        @objc func handleTwoFingerTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            parent.handleTouch(ParsecMouseButton(rawValue: 3), location, gestureRecognizer.state)
        }
    }
}

struct TouchHandlingView_Previews: PreviewProvider {
    static var previews: some View {
        TouchHandlingView(handleTouch: { _, _, _ in
            print("Touch event received in preview")
        })
    }
}
