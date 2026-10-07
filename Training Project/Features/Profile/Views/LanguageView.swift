import SwiftUI 

struct LanguageView: View {

    @State private var showKurdishAlert = false

    @AppStorage("language")
    private var language = "en-GB"

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        NavigationStack {
            List {

                Button {
                    language = "en"
                    dismiss()
                } label: {
                    languageRow(
                        title: "English",
                        code: "en"
                    )
                }

                Button {
                    language = "en-GB"
                    showKurdishAlert = true
                } label: {
                    languageRow(
                        title: "کوردی",
                        code: "en-GB"
                    )
                }
                .alert("Kurdish Language", isPresented: $showKurdishAlert) {
                    Button("OK", role: .cancel) {
                        dismiss()
                    }
                } message: {
                    Text(LocalizedStringKey("kurdishLanguageAlert"))
                }
            }
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func languageRow(
        title: String,
        code: String
    ) -> some View {
        HStack {
            Text(title)
                .padding(8)
                .foregroundStyle(.black)

            Spacer()

            if language == code {
                Image(systemName: "checkmark")
                    .foregroundStyle(.black)
            }
        }
    }
}
