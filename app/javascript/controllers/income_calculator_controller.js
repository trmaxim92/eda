import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hours", "days", "rate", "result", "type"]
  static values = { rate: Number }

  connect() {
    this.recalculate()
  }

  recalculate() {
    const hours = Number(this.hoursTarget.value || 0)
    const days = Number(this.daysTarget.value || 0)
    const rate = Number(this.rateTarget.value || this.rateValue || 0)
    const monthly = Math.round(rate * hours * days * 4.33)
    this.resultTarget.textContent = monthly.toLocaleString("ru-RU")
  }
}
