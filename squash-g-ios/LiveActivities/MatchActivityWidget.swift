import SwiftUI
import ActivityKit
import WidgetKit

struct MatchActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchActivityAttributes.self) { context in
            // Lock Screen UI
            VStack(spacing: 8) {
                HStack {
                    Text(context.attributes.playerAName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text("\(context.state.scoreA)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(SquashGColors.neonCyan)
                }
                
                Divider()
                    .background(SquashGColors.neonCyan.opacity(0.3))
                
                HStack {
                    Text(context.attributes.playerBName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text("\(context.state.scoreB)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(SquashGColors.neonCyan)
                }
                
                Text(Date().elapsedTime(from: context.state.startDate))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.top, 4)
            }
            .padding(16)
            .background(SquashGColors.backgroundDark)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(context.attributes.playerAName)
                            .font(.caption)
                        Text("\(context.state.scoreA)")
                            .font(.title2.bold())
                            .foregroundStyle(SquashGColors.neonCyan)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(context.attributes.playerBName)
                            .font(.caption)
                        Text("\(context.state.scoreB)")
                            .font(.title2.bold())
                            .foregroundStyle(SquashGColors.neonCyan)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.caption2)
                        Text(Date().elapsedTime(from: context.state.startDate))
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
            } compactLeading: {
                // Compact leading
                Text("\(context.state.scoreA)")
                    .font(.caption2.bold())
                    .foregroundStyle(SquashGColors.neonCyan)
            } compactTrailing: {
                // Compact trailing
                Text("\(context.state.scoreB)")
                    .font(.caption2.bold())
                    .foregroundStyle(SquashGColors.neonCyan)
            } minimal: {
                // Minimal UI
                Image(systemName: "sportscourt.fill")
                    .foregroundStyle(SquashGColors.neonCyan)
            }
        }
    }
}
