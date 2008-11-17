import cgi
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext import db
import os
from google.appengine.ext.webapp import template
import json

class Location(db.Model):
  signs = db.StringProperty(required=True, choices=set(["Red", "Blue", "Purple"]))
  address = db.StringProperty(required=True, multiline=True)
  latitude = db.FloatProperty()
  longitude = db.FloatProperty()
  created_at = db.DateTimeProperty(auto_now_add=True)
  updated_at = db.DateTimeProperty(auto_now=True)
  

class MainPage(webapp.RequestHandler):
  def get(self):
    locations_query = Location.all().order('-created_at')
    locations = locations_query.fetch(10)

    template_values = {
      'locations': locations,
      }

    path = os.path.join(os.path.dirname(__file__), 'index.html')
    self.response.out.write(template.render(path, template_values))

class MainPageJson(webapp.RequestHandler):
  def get(self):
    locations_query = Location.all().order('-created_at')
    locations = locations_query.fetch()

    template_values = {
      'locations': locations,
      }

    path = os.path.join(os.path.dirname(__file__), 'index.json')
    self.response.out.write(template.render(path, template_values))

class CreateLocation(webapp.RequestHandler):
  def post(self):
    location = Location(signs = self.request.get('signs'))

    location.address = self.request.get('street')
    location.put()
    self.redirect('/')

application = webapp.WSGIApplication(
                                     [('/', MainPage),
                                      ('/locations', CreateLocation),
                                      ('/locations.json', MainPageJson)],
                                     debug=True)

def main():
  run_wsgi_app(application)

if __name__ == "__main__":
  main()