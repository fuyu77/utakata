import { Controller } from "stimulus"

export default class extends Controller {
  prevent_bootstarap_native_event(e) {
    e.stopPropagation()
  }
}
