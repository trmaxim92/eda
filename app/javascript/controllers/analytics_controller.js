import { Controller } from "@hotwired/stimulus"

// Lightweight event bridge: no PII. Fires only if Metrika/GA globals exist.
export default class extends Controller {
  static values = { event: String, params: Object }

  track(event) {
    const name = this.eventValue || event?.params?.event
    if (!name) return

    const payload = this.hasParamsValue ? this.paramsValue : {}

    if (typeof window.ym === "function" && window.YANDEX_METRIKA_ID) {
      window.ym(window.YANDEX_METRIKA_ID, "reachGoal", name, payload)
    }

    if (typeof window.gtag === "function") {
      window.gtag("event", name, payload)
    }
  }
}
