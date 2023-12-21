const express = require("express");
const redis = require("redis");

// create redis client
const client = redis.createClient({
    host: "redis-server",
    port: 6379
})

const app = express();

client.set("number", 1);
app.get('/', (req,res) => {
    client.get("number", (err,number) => {
        client.set("number", parseInt(number) + 1)
        res.send("안녕하세요. \n\ CountUp: " + number)
    })
})
    
app.listen(PORT, HOST);
console.log('Server is running on http://${HOST}:${PORT}');