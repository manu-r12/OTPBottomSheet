# OTP Bottom Sheet Experiment

An experimental project exploring how OTP (On-Trip) features could be seamlessly integrated into OneBusAway using bottom sheets over map interfaces.

## Purpose

This experiment demonstrates:
- **Bottom sheet integration** for OTP workflows in transit apps
- **Map + content coordination** similar to Apple Maps
- **SwiftUI content** presentation in existing UIKit map views
- **Smooth position transitions** for optimal map visibility during trip planning

## OTP Integration Concept

The demo shows how OneBusAway could present OTP features:
- **Trip planning interface** in bottom sheets over the main map
- **Stop/route details** with adjustable visibility
- **Real-time updates** without losing map context
- **Seamless transitions** between planning and navigation modes

## Key Features

- 🗺️ **Map-first design** - Keep transit map visible while planning
- 📱 **Apple Maps-like behavior** - Familiar interaction patterns
- 🚌 **Transit-focused** - Built for stop/route/trip workflows
- ⚙️ **Configurable positions** - Tip, half, and full detents
- 🔄 **Dynamic content** - Update without dismissing sheet

## Demo Functionality

The example demonstrates:
1. **Full screen map** with floating controls
2. **Location list** in bottom sheet (simulating stops/routes)
3. **Tap list item** → Sheet moves to tip position for better map visibility
4. **Smooth transitions** ideal for OTP user flows

## Technical Implementation

Built using FloatingPanel wrapper with SwiftUI content support for easy OTP feature integration into existing OneBusAway UIKit codebase.

## Requirements

- iOS 13.0+
- FloatingPanel dependency