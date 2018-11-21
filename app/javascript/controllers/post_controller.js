import { Controller } from "stimulus"
import striptags from "striptags"

export default class extends Controller {
  static targets = [ "input", "preview" ]

  initialize() {
    this.previewTarget.innerHTML = this.inputTarget.value
  }

  preview() {
    const value = striptags(this.inputTarget.value, ["ruby", "rt", "rp"])
    this.previewTarget.innerHTML = value
  }

  space() {
    const oldText = this.inputTarget.value
    const cursorPosition = this.inputTarget.selectionStart
    const newText = `${oldText.slice(0, cursorPosition)}　${oldText.substr(cursorPosition)}`
    this.previewTarget.innerHTML = newText
    this.inputTarget.value = newText
    this.inputTarget.focus()
    this.inputTarget.setSelectionRange(cursorPosition + 1, cursorPosition + 1)
  }
}
