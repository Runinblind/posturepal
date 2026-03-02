// AnalyticsDashboardView.swift
// PosturePal Pro - Week 4-5
// Advanced analytics dashboard with SwiftUI Charts

import SwiftUI
import Charts

struct AnalyticsDashboardView: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Period selector
                    periodPicker
                    
                    // Key metrics
                    metricsGrid
                    
                    // Daily trend chart
                    dailyTrendCard
                    
                    // Time of day heatmap
                    hourlyHeatmapCard
                    
                    // Weekday distribution
                    weekdayChartCard
                    
                    // Export & Share
                    actionButtons
                }
                .padding()
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Period Picker
    
    private var periodPicker: some View {
        Picker("Period", selection: $viewModel.selectedPeriod) {
            Text("Week").tag(AnalyticsPeriod.week)
            Text("Month").tag(AnalyticsPeriod.month)
            Text("Year").tag(AnalyticsPeriod.year)
        }
        .pickerStyle(.segmented)
    }
    
    // MARK: - Metrics Grid
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            MetricCard(
                title: "Total Check-Ins",
                value: "\(viewModel.analytics.totalCheckIns)",
                icon: "checkmark.circle.fill",
                color: .blue
            )
            
            MetricCard(
                title: "Compliance Rate",
                value: "\(Int(viewModel.analytics.complianceRate * 100))%",
                icon: "percent",
                color: .green
            )
            
            MetricCard(
                title: "Avg Per Day",
                value: String(format: "%.1f", viewModel.analytics.averagePerDay),
                icon: "chart.line.uptrend.xyaxis",
                color: .orange
            )
            
            MetricCard(
                title: "Peak Hour",
                value: viewModel.peakHourString,
                icon: "clock.fill",
                color: .purple
            )
        }
    }
    
    // MARK: - Daily Trend Chart
    
    private var dailyTrendCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Check-Ins")
                .font(.headline)
            
            Chart(viewModel.analytics.dailyData) { item in
                BarMark(
                    x: .value("Date", item.date, unit: .day),
                    y: .value("Count", item.count)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: viewModel.xAxisStride)) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Hourly Heatmap
    
    private var hourlyHeatmapCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time of Day Distribution")
                .font(.headline)
            
            Chart(viewModel.analytics.hourlyData) { item in
                BarMark(
                    x: .value("Hour", item.hour),
                    y: .value("Count", item.count)
                )
                .foregroundStyle(by: .value("Intensity", item.count))
            }
            .frame(height: 180)
            .chartForegroundStyleScale(range: Gradient(colors: [.green.opacity(0.3), .green]))
            .chartXAxis {
                AxisMarks(values: .stride(by: 3)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let hour = value.as(Int.self) {
                            Text("\(hour):00")
                                .font(.caption2)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Weekday Chart
    
    private var weekdayChartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Day of Week Distribution")
                .font(.headline)
            
            Chart(viewModel.analytics.weekdayData) { item in
                SectorMark(
                    angle: .value("Count", item.count),
                    innerRadius: .ratio(0.5),
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value("Weekday", item.shortWeekday))
                .cornerRadius(5)
            }
            .frame(height: 220)
            .chartLegend(position: .bottom, alignment: .center, spacing: 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: viewModel.exportData) {
                Label("Export Data (CSV)", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: viewModel.shareStats) {
                Label("Share Stats", systemImage: "square.and.arrow.up.on.square")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: - Metric Card Component

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Preview

struct AnalyticsDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsDashboardView(viewModel: AnalyticsViewModel())
    }
}
