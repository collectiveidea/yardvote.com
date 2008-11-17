import cgi
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext import db
import os
from google.appengine.ext.webapp import template
from google.appengine.api import urlfetch
import json
from json import simplejson
import urllib

class Location(db.Model):
  signs = db.StringProperty(required=True, choices=set(["Red", "Blue", "Purple"]))
  address = db.PostalAddressProperty(required=True)
  geocode = db.GeoPtProperty()
  created_at = db.DateTimeProperty(auto_now_add=True)
  updated_at = db.DateTimeProperty(auto_now=True)
  

class MainPage(webapp.RequestHandler):
  def get(self):
    locations_query = Location.all().order('-created_at')
    locations = locations_query.fetch(10)

    template_values = {
      'locations': locations,
      }

    path = os.path.join(os.path.dirname(__file__), 'app', 'views', 'locations', 'index.html')
    self.response.out.write(template.render(path, template_values))

class MainPageJson(webapp.RequestHandler):
  def get(self):
    locations = Location.all().fetch(1000)
    self.response.headers['Content-Type'] = "text/javascript; charset=utf-8"
    callback = self.request.get('callback')
    
    locations_json = []
    for location in locations:
      locations_json.append(json.encode(location))
    locations_json = '{"locations":['+','.join(locations_json)+']}'
    
    if callback != None:
      self.response.out.write(callback+'('+locations_json+');')
    else:
      self.response.out.write(locations_json)

class CreateLocation(webapp.RequestHandler):
  def post(self):
    
    url = 'http://maps.google.com/maps/geo?q=?'+urllib.urlencode({'q':self.request.get('address')})+'&key=ABQIAAAAE9hN8xY_NuBwpBcO0Ku_8xQ137Zavhclf1DNp1U-9spSMxNpkBThjsPwD2OyO0LR7EZjdhbOwKdFpw&sensor=false&output=json'
    
    result = urlfetch.fetch(url)
    coordinates = []
    if result.status_code == 200:
      coordinates = simplejson.loads(result.content)['Placemark'][0]['Point']['coordinates']
      location = Location(
          signs = self.request.get('signs'), 
          address = db.PostalAddress(self.request.get('address')),
          geocode = db.GeoPt(lon = coordinates[0], lat = coordinates[1])
      )
      location.put()
      
      self.response.headers['Content-Type'] = "text/javascript; charset=utf-8"
      callback = self.request.get('callback')
      if callback != None:
        self.response.out.write(callback+'('+json.encode(location)+');')
      else:
        self.response.out.write(json.encode(location))

application = webapp.WSGIApplication(
                                     [('/', MainPage),
                                      ('/locations', CreateLocation),
                                      ('/locations.json', MainPageJson)],
                                     debug=True)

def main():
  run_wsgi_app(application)

if __name__ == "__main__":
  main()