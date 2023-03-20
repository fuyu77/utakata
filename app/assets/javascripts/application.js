// Entry point for the build script in your package.json
import '../stylesheets/application.scss';
import '@hotwired/turbo-rails';
import { Application } from '@hotwired/stimulus';
import { definitionsFromContext } from '@hotwired/stimulus-webpack-helpers';
import 'bootstrap/js/dist/dropdown';
import 'bootstrap/js/dist/tab';
import 'bootstrap-icons/font/bootstrap-icons.css';

document.addEventListener('turbo:load', (event) => {
  window.dataLayer = window.dataLayer || [];
  function gtag() {
    // eslint-disable-next-line prefer-rest-params
    window.dataLayer.push(arguments);
  }

  gtag('js', new Date());
  // eslint-disable-next-line camelcase
  gtag('config', 'UA-27037997-2', { page_location: event.detail.url });
});

window.Stimulus = Application.start();
const context = require.context('./controllers', true, /\.js$/);
window.Stimulus.load(definitionsFromContext(context));
