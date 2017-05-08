class Location
  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def is_in_streetsweeping_zone?
    response = HTTParty.get('http://mapgis.oaklandnet.com/ArcGIS/rest/services/StreetSweepNEW/MapServer/identify', {
      f: :json
      geometry: {
        x: oaklandnet_image_position['n'],
        y: oaklandnet_image_position['y'],
        spatialReference: { wkid: 2227 }
      },
      tolerance: 3,
      returnGeometry: false,
      imageDisplay: '1322,529,96'
    })

    json = JSON.parse(response.body)

    if even_side?
      day = StreetSweepingDay.new(json['results'][0]['DAY_EVEN'])
    elsif odd_side?
      day = StreetSweepingDay.new(json['results'][0]['DAY_ODD'])
    end

    day.today?
  end

  private

  def even_side?
    google_maps_result[0]['short_name'].to_i.even?
  end

  def odd_side?
    google_maps_result[0]['short_name'].to_i.odd?
  end

  def google_maps_result
     @google_maps_result ||= HTTParty.get('https://maps.googleapis.com/maps/api/geocode/json', {
      latlng: "#{@latitude},#{@longitude}",
      key: Rails.application.secrets.google_maps_key
    })

    json = JSON.parse(@google_maps_result)

    json['results'][0]['address_components']
  end

  def street_address
    "#{google_maps_result[0]['short_name']} #{google_maps_result[1]['short_name']}"
  end

  def oaklandnet_image_position
    result = HTTParty.get('http://mapgis.oaklandnet.com/ArcGIS/rest/services/OaklandStreets/GeocodeServer/findAddressCandidates', {
      Street: street_address,
      f: :json,
      outSR: { wkid: 2227 },
      outFields: 'Loc_name'
    })

    json = JSON.parse(result)

    json['candidates']['location']
  end

end
