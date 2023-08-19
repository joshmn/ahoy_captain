import { Controller } from "@hotwired/stimulus";
import "chartjs-chart-geo";
import CountryMap from "helpers/countries"

export default class extends Controller {
  static values = {
    data: Object
  }
  connect() {
    fetch('https://unpkg.com/world-atlas/countries-50m.json').then((r) => r.json()).then((data) => {
      const countries = ChartGeo.topojson.feature(data, data.objects.countries).features;
      const numericToCode = {};
      Object.keys(CountryMap).forEach(key => { numericToCode[CountryMap[key]['Numeric code']] = key })

      countries.forEach(country => {
        const abbrev = numericToCode[country.id];
        country.value = this.dataValue[abbrev]
      })

      const chart = new Chart(this.element.getContext("2d"), {
        type: 'choropleth',
        data: {
          labels: countries.map((d) => d.properties.name),
          datasets: [{
            label: 'Countries',
            data: countries.map((d) => ({feature: d, value: d.value || 0 })),
          }]
        },
        options: {
          showOutline: false,
          showGraticule: false,
          plugins: {
            legend: {
              display: false
            },
          },
          scales: {
            projection: {
              axis: 'x',
              projection: 'equalEarth'
            }
          }
        }
      });
    });
  }
}
