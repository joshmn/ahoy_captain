import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["countriesLink", "top_pagesLink", "devicesLink", "top_sourcesLink"]
  static classes = ["countries", "top_pages", "devices", "top_sources"]

  changeCountries(event) {
    console.log(...this.countriesClasses)
    event.currentTarget.classList.add(...this.countriesClasses)
    this.countriesLinkTargets.forEach((target) => {
      if (target != event.currentTarget) {
        target.classList.remove(...this.countriesClasses)
      }
    })
  }

  changeTopSources(event) {
    event.currentTarget.classList.add(...this.top_sourcesClasses)
    this.top_sourcesLinkTargets.forEach((target) => {
      if (target != event.currentTarget) {
        target.classList.remove(...this.top_sourcesClasses)
      }
    })
  }
  
  changeTopPages(event) {
    event.currentTarget.classList.add(...this.top_pagesClasses)
    this.top_pagesLinkTargets.forEach((target) => {
      if (target != event.currentTarget) {
        target.classList.remove(...this.top_pagesClasses)
      }
    })
  }

  changeDevices(event) {
    event.currentTarget.classList.add(...this.devicesClasses)
    this.devicesLinkTargets.forEach((target) => {
      if (target != event.currentTarget) {
        target.classList.remove(...this.devicesClasses)
      }
    })
  }
}