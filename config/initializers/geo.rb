# http://signs.collectiveidea.com
GOOGLE_MAPS_API_KEY = 'ABQIAAAAE9hN8xY_NuBwpBcO0Ku_8xQ137Zavhclf1DNp1U-9spSMxNpkBThjsPwD2OyO0LR7EZjdhbOwKdFpw'
YAHOO_API_KEY = '16AGnAvV34HZtyfGOV7LAsPG9gwnmA7Sjx24vtcDKKFOoyuLAgkC_VltUvBUUA--'
Geocode.geocoder = Graticule.service(:multi).new [
  Graticule.service(:yahoo).new(YAHOO_API_KEY),
  Graticule.service(:google).new(GOOGLE_MAPS_API_KEY)
]
  
