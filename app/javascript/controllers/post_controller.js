import { Controller } from "stimulus"
import striptags from "striptags"

export default class extends Controller {
  static targets = [ "input", "preview" ]

  initialize() {
    this.previewTarget.innerHTML = this.input
  }

  preview() {
    const value = striptags(this.input, ["ruby", "rt", "rp"])
    this.previewTarget.innerHTML = value
  }

  space() {
    const oldText = this.input
    const cursorPosition = this.inputTarget.selectionStart
    const newText = `${oldText.slice(0, cursorPosition)}　${oldText.substr(cursorPosition)}`
    this.previewTarget.innerHTML = newText
    this.inputTarget.value = newText
    this.inputTarget.focus()
    this.inputTarget.setSelectionRange(cursorPosition + 1, cursorPosition + 1)
  }

  get input() {
    return this.inputTarget.value
  }
}
