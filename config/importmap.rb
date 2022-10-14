# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "leaflet", to: "leaflet/dist/leaflet.js", preload: true
pin "leaflet.markercluster", to: "leaflet.markercluster/dist/leaflet.markercluster.js", preload: true
pin "leaflet.locatecontrol", to: "leaflet.locatecontrol/dist/L.Control.Locate.min.js", preload: true

