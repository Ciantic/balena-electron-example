const { app, BrowserWindow } = require("electron");

const onReady = () => {
    let win = new BrowserWindow({
        width: 1920,
        height: 1080
    });
    win.loadURL("https://google.com");
};

app.on("ready", onReady);
