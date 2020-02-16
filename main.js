const { app, BrowserWindow } = require("electron");

const onReady = () => {
    let win = new BrowserWindow({
        width: 1920,
        height: 1080
    });
    win.loadURL("https://google.com");

    // Some naive error handling...
    win.webContents.on("did-load-fail", () => {
        setTimeout(() => {
            win.loadURL("https://google.com");
        }, 5000);
    })
};

app.on("ready", onReady);
