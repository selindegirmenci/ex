import SwiftUI
import PDFKit

/*
struct DocumentView: View {
    // Creating a URL for the PDF and saving it in the pdfUrl variable
    let pdfUrl = Bundle.main.url(forResource: "fab1Generator", withExtension: "pdf")!
    @State private var displayMode: PDFDisplayMode = .singlePage // Initial display mode
    
    var body: some View {
        VStack {
            Image(systemName: "doc.viewfinder")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("PDF Viewer")
                .foregroundColor(.accentColor)
            PDFKitView(url: pdfUrl, displayMode: $displayMode)
                .onAppear {
                    // Set initial display mode or other configurations
                    PDFView.appearance().displayMode = displayMode
                }
                .scaledToFill()
        }
        .padding()
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL // new variable to get the URL of the document
    @Binding var displayMode: PDFDisplayMode // To bind the display mode

    func makeUIView(context: Context) -> PDFView {
        // Creating a new PDFView and adding a document to it
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.displayMode = displayMode // Set the initial display mode
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.displayMode = displayMode // Update the display mode if it changes
    }
}
*/

struct DocumentView: View {
  
    let pdfUrl = Bundle.main.url(forResource: "fab1Generator", withExtension: "pdf")!
    @State private var displayMode: PDFDisplayMode = .singlePageContinuous //.singlePage
    @State private var pdfScale: CGFloat = 1.0 // Variable to hold the scale factor

    var body: some View {
        VStack {
            Image(systemName: "doc.viewfinder")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("PDF Viewer")
                .foregroundColor(.accentColor)
            PDFKitView(url: pdfUrl, displayMode: $displayMode, pdfScale: $pdfScale)
                .onAppear {
                    // Set initial display mode or other configurations
                    PDFView.appearance().displayMode = displayMode
                }
                .gesture(MagnificationGesture()
                    .onChanged { scale in
                        pdfScale = scale
                    }
                )
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL // new variable to get the URL of the document
    @Binding var displayMode: PDFDisplayMode // To bind the display mode
    @Binding var pdfScale: CGFloat // To bind the scale factor

    func makeUIView(context: Context) -> PDFView {
        // Creating a new PDFView and adding a document to it
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        //pdfView.displayMode = displayMode // Set the initial display mode
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true // Enable auto scaling
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit // Set the minimum scale factor
        pdfView.usePageViewController(true)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
       // uiView.displayMode = displayMode // Update the display mode if it changes
       // uiView.scaleFactor = pdfScale // Update the scale factor
    }
}
   
/*
struct DocumentView: View {
    let pdfUrl = Bundle.main.url(forResource: "fab1Generator", withExtension: "pdf")!
    @State private var displayMode: PDFDisplayMode = .singlePage
    @State private var pdfScale: CGFloat = 1.0 // Variable to hold the scale factor

    var body: some View {
        PDFKitViewController(url: pdfUrl, displayMode: $displayMode, pdfScale: $pdfScale)
            .onAppear {
                // Set initial display mode or other configurations
                PDFView.appearance().displayMode = displayMode
            }
            .gesture(MagnificationGesture()
                .onChanged { scale in
                    pdfScale = scale
                }
            )
            .scaledToFit() // Ensure the view scales properly
    }
}

struct PDFKitViewController: UIViewControllerRepresentable {
    let url: URL
    @Binding var displayMode: PDFDisplayMode
    @Binding var pdfScale: CGFloat

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: PDFKitViewController

        init(parent: PDFKitViewController) {
            self.parent = parent
        }

        func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            parent.pdfScale = scale
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let pdfViewController = UIViewController()
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.displayMode = displayMode
        pdfView.autoScales = true
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit

        let scrollView = UIScrollView()
        scrollView.addSubview(pdfView)
        scrollView.delegate = context.coordinator

        pdfViewController.view = scrollView
        return pdfViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let scrollView = uiViewController.view as? UIScrollView, let pdfView = scrollView.subviews.first as? PDFView {
            pdfView.displayMode = displayMode
            pdfView.scaleFactor = pdfScale
        }
    }
}



struct DocumentView_Preview: PreviewProvider {
    static var previews: some View {
        DocumentView()
    }
}
 */
