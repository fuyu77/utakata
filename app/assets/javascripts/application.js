// Entry point for the build script in your package.json
import 'bootstrap/dist/css/bootstrap.css';
import '../stylesheets/application.css';
import '@hotwired/turbo-rails';
import { Application } from '@hotwired/stimulus';
import { definitionsFromContext } from '@hotwired/stimulus-webpack-helpers';
import 'bootstrap/js/dist/dropdown';
import 'bootstrap/js/dist/modal';
import 'bootstrap/js/dist/tab';
import 'bootstrap-icons/font/bootstrap-icons.css';
import './analytics';

window.Stimulus = Application.start();
const context = require.context('./controllers', true, /\.js$/);
window.Stimulus.load(definitionsFromContext(context));
