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
                    
                    Image(uiImage: generateQRCode(fromString: "\(name)\n\(email)"))
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
            }
            .navigationTitle("Your code")
        }
    }

    func generateQRCode(fromString str: String ) -> UIImage {
        imageFilter.message = Data(str.utf8)

        if let ciImage = imageFilter.outputImage {
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
