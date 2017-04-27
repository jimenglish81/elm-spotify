import './styles/styles.css';

const Elm = require('./Main.elm');
const mountNode = document.getElementById('main');

const app = Elm.Main.embed(mountNode, {
  clientId: SPOTIFY_CLIENT_ID || '',
  redirectUrl: SPOTIFY_REDIRECT_URL || '',
});
