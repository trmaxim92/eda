import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "slug", "list", "option", "empty"]

  connect() {
    this.close()
  }

  open() {
    this.filter()
    this.listTarget.hidden = false
  }

  closeLater() {
    window.setTimeout(() => this.close(), 150)
  }

  close(event) {
    if (event && this.element.contains(event.target)) return
    if (this.hasListTarget) this.listTarget.hidden = true
  }

  filter() {
    const query = this.normalize(this.inputTarget.value)
    let visible = 0

    this.optionTargets.forEach((option) => {
      const match = !query || this.normalize(option.dataset.name).includes(query)
      option.hidden = !match
      if (match) visible += 1
    })

    if (this.hasEmptyTarget) this.emptyTarget.hidden = visible > 0
    this.listTarget.hidden = false
  }

  pick(event) {
    const option = event.currentTarget
    this.inputTarget.value = option.dataset.name
    this.slugTarget.value = option.dataset.slug
    this.close()
    this.element.requestSubmit()
  }

  keydown(event) {
    if (event.key === "Escape") {
      this.close()
      return
    }

    if (event.key !== "Enter") return

    event.preventDefault()
    const first = this.optionTargets.find((option) => !option.hidden)
    if (!first) return

    this.inputTarget.value = first.dataset.name
    this.slugTarget.value = first.dataset.slug
    this.close()
    this.element.requestSubmit()
  }

  normalize(value) {
    return (value || "").toString().toLowerCase().replaceAll("ё", "е").trim()
  }
}
