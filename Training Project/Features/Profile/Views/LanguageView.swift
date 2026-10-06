import SwiftUI 

struct LanguageView: View {

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
                    dismiss()
                } label: {
                    languageRow(
                        title: "کوردی",
                        code: "en-GB"
                    )
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
