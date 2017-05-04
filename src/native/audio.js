const sendMsg = (app) => (arg) => {
  app.ports.audioFinished.send(arg);
};

const addTask = (app) => {
  const audio = new Audio();
  const sendFinished = sendMsg(app);

  audio.preload = 'auto';
  audio.addEventListener('error', () => {
    sendFinished(audio.src);
  }, false);
  audio.addEventListener('ended', () => {
    sendFinished(audio.src);
  }, false);

  app.ports.audioStart.subscribe((src) => {
    if (src === '') {
      return;
    }

    if (audio.src !== src) {
      audio.src = src;
      audio.load();
    }
    audio.play();
  });

  app.ports.audioStop.subscribe(() => {
    audio.pause();
  });
};

export default addTask;
