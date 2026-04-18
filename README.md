 # bitaksi-case                                                                                                                                                                                                                                  
Görünür harita bölgesindeki uçuşları [OpenSky Network](https://opensky-network.org) API'si üzerinden neredeyse gerçek zamanlı olarak gösteren bir iOS uygulaması.                                                                                                                                                                                                 
  ## Özellikler
   **Canlı uçuş haritası** — MapKit üzerinde görünür bölgedeki uçuşların anlık konumu
   **Otomatik yenileme** — kullanıcı haritayı hareket ettirdikten 5 sn sonra, 5'er saniyelik aralıklarla bbox güncellenir (Combine switchToLatest)
   **Ülke bazlı filtre** — uçuşları originCountry alanına göre filtreleme
  **Zoom kontrolleri** — haritaya overlay'lenmiş özel zoom butonları
   **OAuth2 client credentials** akışıyla token alımı
  
   ## Mimari
  
   VIPER katmanlı yapı:
   Home/
   - HomeViewController   // UI + MapKit
   - HomePresenter        // state + Combine auto-refresh akışı
   - HomeInteractor       // token + states çağrıları
   - HomeRouter           // navigation
   - Model              // BoundingBox, Endpoint item
   - Response            // decoding (pozisyonel array → FlightState)
  
   ## Kullanılan Teknolojiler

   - **UIKit** + **MapKit** — storyboard tabanlı arayüz ve harita
   - **Combine** — debounce / switchToLatest ile bölge-bazlı auto-refresh
   - **Alamofire** — HTTP katmanı
   - **Swift Package Manager** — local API modülü
  
   ## Çalıştırma
  1. bitaksi-case.xcodeproj dosyasını Xcode ile açın.
  2. OpenSky client bilgileri HomeEndpointItem.swift içinde tanımlıdır. Kendi credential'ınızla değiştirebilirsiniz.
  3. Bir simülatör/cihaz seçip çalıştırın.
  
   ## API
   - POST /auth/realms/opensky-network/protocol/openid-connect/token — erişim token'ı
   - GET  /states/all?lamin&lomin&lamax&lomax — bounding box içindeki uçuş durumları
