import { Controller } from "@hotwired/stimulus"

// Ориентиры ₽/час для Москвы по данным найма Яндекс Еды / Яндекс Про
// (динамичный формат: база + км/время + доплаты; не гарантия дохода).
const MOSCOW_RATES = {
  pedestrian: { default: 400, options: [300, 350, 400, 450, 500, 534] },
  bike: { default: 450, options: [350, 400, 450, 500, 550] },
  auto: { default: 520, options: [400, 450, 500, 520, 560, 600] }
}

export default class extends Controller {
  static targets = ["hours", "days", "rate", "result", "type"]
  static values = { rate: Number }

  connect() {
    this.syncRateOptions()
    this.recalculate()
  }

  changeType() {
    this.syncRateOptions(true)
    this.recalculate()
  }

  syncRateOptions(forceDefault = false) {
    if (!this.hasTypeTarget || !this.hasRateTarget) return

    const key = this.typeTarget.value || "pedestrian"
    const config = MOSCOW_RATES[key] || MOSCOW_RATES.pedestrian
    const previous = Number(this.rateTarget.value || 0)
    const selected = forceDefault || !config.options.includes(previous)
      ? config.default
      : previous

    this.rateTarget.innerHTML = config.options
      .map((rate) => `<option value="${rate}"${rate === selected ? " selected" : ""}>${rate}</option>`)
      .join("")
  }

  recalculate() {
    const hours = Number(this.hoursTarget.value || 0)
    const days = Number(this.daysTarget.value || 0)
    const rate = Number(this.rateTarget.value || this.rateValue || 0)
    const monthly = Math.round(rate * hours * days * 4.33)
    this.resultTarget.textContent = monthly.toLocaleString("ru-RU").replace(/\u00A0/g, " ")
  }
}
