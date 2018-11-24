import { Controller } from "stimulus"
import striptags from "striptags"

export default class extends Controller {
  static targets = [ "input", "preview" ]

  initialize() {
    this.preview = this.input
  }

  previewPost() {
    // <ruby><rt>以外のHTML element, attiributeをプレビューに反映しない
    const value = striptags(this.input, ["ruby", "rt"])
      .replace(/<ruby[^>]/g, "")
      .replace(/<rt[^>]/g, "")
    this.preview = value
  }

  space() {
    const oldText = this.input
    const cursorPosition = this.inputTarget.selectionStart
    const newText = `${oldText.slice(0, cursorPosition)}　${oldText.substr(cursorPosition)}`
    this.preview = newText
    this.input = newText
    this.inputTarget.focus()
    this.inputTarget.setSelectionRange(cursorPosition + 1, cursorPosition + 1)
  }

  get input() {
    return this.inputTarget.value
  }

  set input(value) {
    return this.inputTarget.value = value
  }
  
  set preview(html) {
    this.previewTarget.innerHTML = html
  }
}
