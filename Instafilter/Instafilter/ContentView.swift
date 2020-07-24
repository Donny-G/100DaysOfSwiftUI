//
//  ContentView.swift
//  Instafilter
//
//  Created by DeNNiO   G on 08.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterGain: Double = 1
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingFilterSheet = false
    @State private var processedImage: UIImage?
    @State private var showAlert = false
    @State private var filterName = "SepiaTone"
    
    @State private var intensityInactive = false
    @State private var radiusInactive = false
    @State private var gainInactive = false
    @State private var alertMessage = "Hi"
    @State private var alertText = "Error"
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKes = currentFilter.inputKeys
        if inputKes.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity * filterGain, forKey: kCIInputIntensityKey)
            radiusInactive = true
            gainInactive = false
            intensityInactive = false
        }
        if inputKes.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * filterGain, forKey: kCIInputRadiusKey)
            intensityInactive = true
            gainInactive = false
            radiusInactive = false
        }
        if inputKes.contains(kCIInputScaleKey) {
            
            currentFilter.setValue(filterIntensity * filterGain, forKey: kCIInputScaleKey)
            radiusInactive = true
            gainInactive = false
            intensityInactive = false
        }
        
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    var body: some View {
        let intensity = Binding<Double> (
            get: {
                self.filterIntensity
        },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
        }
        )
        
        let radius = Binding<Double> (
            get: { self.filterRadius
        },
            set:{
                self.filterRadius = $0
                self.applyProcessing()
        }
        )
        
        let gain = Binding<Double> (
            get: { self.filterGain
        }, set: {
            self.filterGain = $0
            self.applyProcessing()
        })
        
       return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    if image != nil {
                        image?
                        .resizable()
                        .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                    .disabled(intensityInactive)
                }.padding(.vertical)
                
                HStack {
                    Text("Radius")
                    Slider(value: radius)
                    .disabled(radiusInactive)
                    }.padding(.vertical)
                
                HStack {
                    Text("Gain")
                    Slider(value: gain, in: 1...300, step: 2)
                    .disabled(gainInactive)
                    }.padding(.vertical)
                
                HStack {
                    VStack(alignment: .leading) {
                    Text(filterName)
                        .foregroundColor(.secondary)
                    Button("Change Filter") {
                        self.showingFilterSheet = true
                        }
                    }
                    Spacer()
                    
                    Button("Save") {
                        if self.image == nil {
                            self.alertMessage = "Please choose image first"
                            self.showAlert = true
                        }
                        guard let processedImage = self.processedImage else { return }
                        let imageSaver = ImageSaver()
                        imageSaver.successHandler = {
                            self.alertText = "Congratulations"
                            self.alertMessage = "Image was successfully saved"
                            self.showAlert = true
                        }
                        imageSaver.errorHandler = {
                            self.alertMessage = "Oops: \($0.localizedDescription)"
                            self.showAlert = true
                        }
                        
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }
            }
            .padding([.horizontal, .bottom])
        .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
        }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertText), message: Text(alertMessage), dismissButton: .cancel(Text("Ok")))
            }
        .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Crystallize")) {
                        self.filterName = "Crystallize"
                        self.setFilter(CIFilter.crystallize())
                    },
                    .default(Text("Edges")) {
                        self.filterName = "Edges"
                        self.setFilter(CIFilter.edges())
                    },
                    .default(Text("Gaussian Blur")) {
                        self.filterName = "Gaussian Blur"
                        self.setFilter(CIFilter.gaussianBlur())
                    },
                    .default(Text("Pixellate")) {
                        self.filterName = "Pixellate"
                        self.setFilter(CIFilter.pixellate())
                    },
                    .default(Text("SepiaTone")) {
                        self.filterName = "SepiaTone"
                        self.setFilter(CIFilter.sepiaTone())
                    },
                    .default(Text("Unsharp Mask")) {
                        self.filterName = "Unsharp Mask"
                        self.setFilter(CIFilter.unsharpMask())
                    },
                    .default(Text("Motion Blur")) {
                        self.filterName = "Motion Blur"
                        self.setFilter(CIFilter.motionBlur())
                    },
                    
                    
                    .default(Text("Vignette")) {
                        self.filterName = "Vignette"
                        self.setFilter(CIFilter.vignette())
                    },
                    .cancel()
                
                
                ])
        }
        
            
        }
        
       
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
