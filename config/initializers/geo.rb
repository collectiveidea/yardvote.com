# http://signs.collectiveidea.com
GOOGLE_MAPS_API_KEY = 'ABQIAAAAKU0JUXXK40nehgHiZGe2JRQ137Zavhclf1DNp1U-9spSMxNpkBQvMiH0_iZ1zc5XqUp7aGfZk47vcA'
YAHOO_API_KEY = '16AGnAvV34HZtyfGOV7LAsPG9gwnmA7Sjx24vtcDKKFOoyuLAgkC_VltUvBUUA--'
Geocode.geocoder = Graticule.service(:multi).new [
  Graticule.service(:yahoo).new(YAHOO_API_KEY),
  Graticule.service(:google).new(GOOGLE_MAPS_API_KEY)
]
  
