class Location
  def initialize(latitude:, longitude:)
    @latitude = latitude
    @longitude = longitude
  end

  def in_streetsweeping_zone_on?(date)
    coordinate_diameter = 3000

    response = HTTParty.get('http://mapgis.oaklandnet.com/ArcGIS/rest/services/StreetSweepNEW/MapServer/identify', {
      query: {
        f: :json,
        geometry: JSON.dump({
          x: oaklandnet_image_position['x'],
          y: oaklandnet_image_position['y'],
          spatialReference: { wkid: 2227 }
        }),
        mapExtent: JSON.dump({
          xmin: oaklandnet_image_position['x'].to_i - coordinate_diameter,
          ymin: oaklandnet_image_position['y'].to_i - coordinate_diameter,
          xmax: oaklandnet_image_position['x'].to_i + coordinate_diameter,
          ymax: oaklandnet_image_position['y'].to_i + coordinate_diameter,
          spatialReference: { wkid: 2227 }
        }),
        tolerance: 3,
        returnGeometry: false,
        imageDisplay: '1322,529,96'
      }
    })

    json = JSON.parse(response.body)

    if even_side?
      schedule = StreetSweepingSchedule.new(json['results'][0]['attributes']['DAY_EVEN'])
    elsif odd_side?
      schedule = StreetSweepingSchedule.new(json['results'][0]['attributes']['DAY_ODD'])
    else
      raise 'Something went haywire'
    end

    schedule.sweeping_on?(date)
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
      query: {
        latlng: "#{@latitude},#{@longitude}",
        key: Rails.application.secrets.google_maps_key
      }
    })

    json = JSON.parse(@google_maps_result.body)

    json['results'][0]['address_components']
  end

  def street_address
    "#{google_maps_result[0]['short_name']} #{google_maps_result[1]['short_name']}"
  end

  def oaklandnet_image_position
    result = @oaklandnet_image_position_result ||= HTTParty.get('http://mapgis.oaklandnet.com/ArcGIS/rest/services/OaklandStreets/GeocodeServer/findAddressCandidates', {
      query: {
        Street: street_address,
        f: :json,
        outSR: { wkid: 2227 },
        outFields: 'Loc_name'
      }
    })

    json = JSON.parse(result.body)

    json['candidates'][0]['location']
  end
end
