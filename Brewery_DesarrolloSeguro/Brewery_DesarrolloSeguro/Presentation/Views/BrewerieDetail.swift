import SwiftUI
import MapKit

struct BrewerieDetail: View {
    @State private var cameraPosition: MapCameraPosition
    
    var viewModel: BreweryViewModel
    
    var brewerySelected: Brewery
    
    init(viewModel: BreweryViewModel, brewerySelected: Brewery) {
        self.viewModel = viewModel
        self.brewerySelected = brewerySelected
        
        let latitude = brewerySelected.latitude ?? 0.0
        let longitude = brewerySelected.longitude ?? 0.0
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let camera = MapCamera(
            centerCoordinate: coordinate,
            distance: 1000,
            heading: 0,
            pitch: 0
        )
        
        self._cameraPosition = State(initialValue: MapCameraPosition.camera(camera))
    }
    
    var body: some View {
        ZStack {
            Image("FondoDetail")
                .resizable()
                .ignoresSafeArea()
               
            
            VStack {
                Spacer().frame(height: 70)
                
                Map(position: $cameraPosition) {
                    if coordinatesAvailable() {
                        Marker("", coordinate: CLLocationCoordinate2D(latitude: brewerySelected.latitude ?? 0,
                                                                      longitude: brewerySelected.longitude ?? 0))
                            .tint(.red)
                    }
                }
                .frame(height: 500)
                .cornerRadius(12)
                
                Spacer().frame(height: 10)
                
                Text(brewerySelected.name)
                    .font(.custom("Copperplate-Bold", size: 20))
                    .foregroundColor(.black)
                    .padding(20)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.95, green: 0.89, blue: 0.78),
                                    Color(red: 0.82, green: 0.63, blue: 0.27)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [.black, .black],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        }
                    )
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 3, y: 3)
                    .padding()
                
                Button {
                    viewModel.toggleFavorite(brewerySelected)
                    
        
                } label: {
                    Image(systemName: viewModel.favoritesBeweryes.contains(where: { $0.id == brewerySelected.id }) ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 2, y: 2)
                        .tint(.greenBrewery)
                }
                .alert(isPresented: Binding(
                                // Hacemos un binding manual ya que el vm puede ser opcional
                                    get: { viewModel.showAlertFavorite },
                                    set: { _ in viewModel.dismissFavoriteAlert() }
                                )) {
                                    Alert(
                                        title: Text("Aviso al usuario"),
                                        message: Text("Debe logearse para poder guardar sus favoritos"),
                                        dismissButton: .default(Text("Aceptar")) {
                                            viewModel.dismissFavoriteAlert()
                                        }
                                    )
                                }            }
            .padding(.horizontal)
        }
    }
    
    private func coordinatesAvailable() -> Bool {
        if let lat = brewerySelected.latitude, let lon = brewerySelected.longitude {
            return lat != 0 && lon != 0
        }
        return false
    }
}

#Preview {
    BrewerieDetail(
        viewModel: BreweryViewModel(useCase: BreweriesUseCaseMock(),
                                              authentication: Authentication(context: AppState().authenticationContext)),
        brewerySelected: Brewery(
            id: "701239cb-5319-4d2e-92c1-129ab0b3b440",
            name: "Bière de la Plaine Mock",
            breweryType: "micro",
            address1: "16 Rue Saint Pierre",
            address2: nil,
            address3: nil,
            city: "Marseille",
            stateProvince: "Bouche du Rhône",
            postalCode: "13006",
            country: "France",
            longitude: 5.38767154,
            latitude: 43.29366192,
            phone: "491473254",
            websiteURL: "https://brasseriedelaplaine.fr/",
            state: "Bouche du Rhône",
            street: "16 Rue Saint Pierre"
        )
    )
}
