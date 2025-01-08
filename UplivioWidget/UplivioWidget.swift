//import SwiftUI
//import WidgetKit
//
//// Bu sınıf, widget'ı besleyen sağlayıcıdır (Provider). Bu, widget'e zaman çizelgesi (timeline) bilgileri sağlar.
//struct Provider: AppIntentTimelineProvider {
//    // Placeholder: Widget'in ilk yüklenirken gösterilecek placeholder verisi.
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), message: "Loading...") // Placeholder, "Loading..." mesajıyla gösterilir.
//    }
//
//    // Snapshot: Widget'te gösterilecek statik veriyi oluşturur. Gerçek zamanlı gösterim sırasında bu fonksiyon çağrılır.
//    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
//        SimpleEntry(date: Date(), message: "Believe in yourself!") // Snapshot için sabit bir mesaj.
//    }
//
//    // Timeline: Widget'teki verinin zaman çizelgesini oluşturur. Bu, widget'in verilerinin ne sıklıkla güncelleneceğini belirler.
//    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
//        var _: [SimpleEntry] = []
//
//        // ONEMLI
//        let currentLanguage = Locale.preferredLanguages.first?.prefix(2) == "tr" ? "tr" : "en"
//        let viewModel = MessageViewModel()
//        viewModel.loadMessages(for: currentLanguage)
//        let message = viewModel.getMessageForToday()
//
//        // Şu anki zaman dilimini alıyoruz.
//        let currentDate = Date()
//        let entry = SimpleEntry(date: currentDate, message: message) // Çekilen mesaj ile bir zaman dilimi girdisi oluşturuluyor.
//
//        // Widget'in bir sonraki saat diliminde güncellenmesi için bir saat sonrasını belirtiyoruz.
//        // Burada degisiklik yapacagiz.
//        // ONEMLI
//        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
//        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate)) // Widget 1 saat sonra güncellenir.
//
//        return timeline
//    }
//
//    // Burada mesaji cekecegiz.
//    // ONEMLI
//}
//
//// Widget'teki her bir zaman dilimi girdisinin (entry) verilerini tanımlar.
//struct SimpleEntry: TimelineEntry {
//    let date: Date // Zaman bilgisi.
//    let message: String // Gösterilecek mesaj.
//}
//
//
//// Widget arayüzü (SwiftUI kullanılarak oluşturulan görünüm).
//struct UplivioWidgetEntryView: View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack(alignment: .center) {
//                let colors = BackgroundColors.randomTwoColors()
//
//                LinearGradient(gradient: Gradient(colors: [
//                    Color(colors.color1),
//                    Color(UIColor.white.withAlphaComponent(0.8)),
//                    Color(colors.color2)
//                ]), startPoint: .topTrailing, endPoint: .bottomLeading)
//                .aspectRatio(contentMode: .fill)
//                // ios 17
//                .containerRelativeFrame(
//                            [.horizontal, .vertical],
//                            alignment: .topLeading
//                        )
//                
//                .ignoresSafeArea() // Ignore safe areas
//
//                VStack {
//                    Text(entry.message)
//                        .font(.system(size: 18))
//                        .multilineTextAlignment(.center)
//                        .padding()
//                        .foregroundColor(Color(UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)))
//                }
//            }
//            .frame(width: geo.size.width, height: geo.size.height) // Ensure ZStack fills the entire widget
//        }
//    }
//}
//
//
//// Widget'ın ana yapılandırması.
//struct UplivioWidget: Widget {
//    let kind: String = "UplivioWidget" // Widget kimliği.
//
//    var body: some WidgetConfiguration {
//        // AppIntentConfiguration kullanarak widget yapılandırmasını oluşturur.
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            UplivioWidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget) // Widget arka planı tercihi.
//        }
//    }
//}
//
//// SwiftUI preview, widget'in nasıl görüneceğini önceden görmek için kullanılır.
//#Preview(as: .systemMedium) {
//    UplivioWidget()
//} timeline: {
//    SimpleEntry(date: .now, message: "Believe in yourself! Believe in yourself! Believe in yourself!")
//}


import SwiftUI
import WidgetKit

@main
struct UplivioWidget: Widget {
    let kind: String = "UplivioWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            UplivioWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Uplivio Widget")
        .description("Displays a daily motivational message.")
        .supportedFamilies([.systemSmall, .systemMedium]) // iOS 16 uyumlu boyutlar
    }
}

// Provider: Widget'a veri sağlayan sınıf
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), message: "Loading...") // Placeholder mesajı
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        // Snapshot için örnek bir mesaj göster
        let entry = SimpleEntry(date: Date(), message: "Example Message")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        // Günlük mesajı çek
        let viewModel = MessageViewModel()
        let message = viewModel.getMessageForToday()

        // Zaman çizelgesi oluştur
        let currentDate = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!

        let entry = SimpleEntry(date: currentDate, message: message)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

// Widget'teki her bir zaman dilimi girdisinin (entry) verilerini tanımlar
struct SimpleEntry: TimelineEntry {
    let date: Date
    let message: String
}

// Widget arayüzü (SwiftUI kullanılarak oluşturulan görünüm)
struct UplivioWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        GeometryReader { geo in
            ZStack {
                let colors = BackgroundColors.randomTwoColors()

                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(colors.color1),
                        Color.white.opacity(0.8),
                        Color(colors.color2)
                    ]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .ignoresSafeArea()

                VStack {
                    Text(entry.message)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.black)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
