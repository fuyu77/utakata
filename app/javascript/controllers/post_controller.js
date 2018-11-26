import { Controller } from "stimulus"
import striptags from "striptags"

export default class extends Controller {
  static targets = [ "input", "preview" ]

  initialize() {
    this.preview = this.input
      .replace(/<tate>/g, '<span class="tate">')
      .replace(/<\/tate>/g, "</span>")
  }

  previewPost() {
    // <ruby><rt>以外のHTML element, attiributeをプレビューに反映しない
    const value = striptags(this.input, ["ruby", "rt", "tate"])
      .replace(/<ruby[^>]/g, "")
      .replace(/<rt[^>]/g, "")
      .replace(/<tate>/g, '<span class="tate">')
      .replace(/<\/tate>/g, "</span>")
      .replace(/<tate[^>]/g, "")
      .replace(/<tate[^>]/g, "")
    this.preview = value
  }

  ruby() {
    const start = this.inputTarget.selectionStart
    const end = this.inputTarget.selectionEnd
    const range = end - start
    const oldText = this.input
    const newText = `${oldText.slice(0, start)}<ruby>${oldText.slice(start, end)}<rt></rt></ruby>${oldText.slice(end)}`
    this.preview = newText
    this.input = newText
    this.inputTarget.focus()
    this.inputTarget.setSelectionRange(start + 10 + range, start + 10 + range)
  }

  upright() {
    const start = this.inputTarget.selectionStart
    const end = this.inputTarget.selectionEnd
    const range = end - start
    const oldText = this.input
    const newText = `${oldText.slice(0, start)}<tate>${oldText.slice(start, end)}</tate>${oldText.slice(end)}`
    this.preview = newText
    this.input = newText
    this.inputTarget.focus()
    this.inputTarget.setSelectionRange(start + 13 + range, start + 13 + range)
    this.previewPost()
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
