// Entry point for the build script in your package.json
import '../stylesheets/application.scss';
import '@hotwired/turbo-rails';
import { Application } from '@hotwired/stimulus';
import { definitionsFromContext } from '@hotwired/stimulus-webpack-helpers';
import 'bootstrap/js/dist/dropdown';
import 'bootstrap/js/dist/tab';
import 'bootstrap-icons/font/bootstrap-icons.css';

document.addEventListener('turbo:load', (event) => {
  window.dataLayer ||= [];
  function gtag() {
     
    window.dataLayer.push(arguments);
  }

  gtag('js', new Date());
   
  gtag('config', 'G-PB35HE8YLS', { page_location: event.detail.url });
  gtag('event', 'page_view', {
     
    page_location: event.detail.url,
     
    send_to: 'G-PB35HE8YLS',
  });
});

window.Stimulus = Application.start();
const context = require.context('./controllers', true, /\.js$/);
window.Stimulus.load(definitionsFromContext(context));
