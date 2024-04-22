import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct docContentView: View {
    @State private var pdfURLs: [URL]
    @State private var showingDocumentPicker = false

    init() {
        // Hardcoded sample PDFs
        let hardcodedPDFs = [
            Bundle.main.url(forResource: "fab1Generator", withExtension: "pdf")!,
            Bundle.main.url(forResource: "testPDF", withExtension: "pdf")!,
            Bundle.main.url(forResource: "generator", withExtension: "pdf")!
        ]
        self._pdfURLs = State(initialValue: hardcodedPDFs)
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(pdfURLs, id: \.self) { pdfURL in
                        NavigationLink(destination: newestPDFViewer(pdfURL: pdfURL)) {
                            Text(pdfURL.lastPathComponent)
                        }
                    }
                    .onDelete(perform: deletePDF) // Enable swipe-to-delete
                }
            }
            .navigationTitle("Documents")
            .navigationBarItems(trailing:
                Button(action: {
                    // Show document picker
                    showingDocumentPicker.toggle()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPickerView(pdfURLs: $pdfURLs)
            }
        }
    }

    func deletePDF(at offsets: IndexSet) {
        pdfURLs.remove(atOffsets: offsets)
    }
}


struct DocumentPickerView: UIViewControllerRepresentable {
    @Binding var pdfURLs: [URL]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView

        init(_ documentPickerView: DocumentPickerView) {
            self.parent = documentPickerView
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.pdfURLs.append(contentsOf: urls)
        }
    }
}

struct newestPDFViewer: View {
    let pdfURL: URL

    var body: some View {
        newestPDFKitView(url: pdfURL)
            .navigationBarTitle(Text(pdfURL.lastPathComponent), displayMode: .inline)
    }
}

struct newestPDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct docContentView_Previews: PreviewProvider {
    static var previews: some View {
        docContentView()
    }
}





