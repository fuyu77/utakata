import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "input", "preview" ]

  preview() {
    this.previewTarget.innerHTML = this.inputTarget.value
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
