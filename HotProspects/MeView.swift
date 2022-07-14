//
//  MeView.swift
//  HotProspects
//
//  Created by QBUser on 14/07/22.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {

    @State private var name = "Anonymus"
    @State private var email = ""
    @State private var QRImage = UIImage()

    let context = CIContext()
    let imageFilter = CIFilter.qrCodeGenerator()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .font(.title)

                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .font(.title)
                    
                    Image(uiImage: QRImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .contextMenu {
                            Button {
                                ImageSaver().writeToPhotoAlbum(image: QRImage)
                            } label: {
                                Label("Save to Photos", systemImage: "square.and.arrow.down")
                            }
                        }
                }
            }
            .navigationTitle("Your code")
            .onAppear { updateCode() }
            .onChange(of: name) { _ in updateCode() }
            .onChange(of: email) { _ in updateCode() }
        }
    }

    func updateCode() {
        QRImage = generateQRCode(fromString: "\(name)\n\(email)")
    }

    func generateQRCode(fromString str: String ) -> UIImage {
        imageFilter.message = Data(str.utf8)

        if let ciImage = imageFilter.outputImage {
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
