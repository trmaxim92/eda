import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  filter() {
    const query = this.normalize(this.inputTarget.value)

    this.element.querySelectorAll("[data-city-filter-item]").forEach((item) => {
      const match = !query || this.normalize(item.dataset.name).includes(query)
      item.hidden = !match
    })

    this.element.querySelectorAll("[data-city-filter-region]").forEach((block) => {
      const visible = block.querySelectorAll("[data-city-filter-item]:not([hidden])").length
      block.hidden = visible === 0
    })
  }

  normalize(value) {
    return (value || "").toString().toLowerCase().replaceAll("ё", "е").trim()
  }
}
