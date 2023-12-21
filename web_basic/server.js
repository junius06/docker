const express = require("express");
const PORT = 8888;

const app = express();

app.get('/', (req,res) => {
    res.send("This is test.")
});

app.listen(PORT, () => {
    console.log("Server is running......");
});
