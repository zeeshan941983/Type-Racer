const express = require("express");
const app = express();
const http = require('http');
const mongoose = require("mongoose");

app.use(express.json());
const URL = 'mongodb://localhost:27017/typeRacer';
const port = process.env.PORT || 8080;
const server = http.createServer(app);
var io = require("socket.io")(server);
const gamemodel = require("./model/game");
const getSentence = require("./api/getSentance");
const { time } = require("console");




///listioning to socket io event the client
io.on('connection', (socket) => {

    socket.on('create-game', async ({ nickname }) => {   //or we can write (data) istead of {nickname}
        try {

            let game = new gamemodel();
            const sentance = await getSentence();
            game.words = sentance;
            let player = {
                nickname,
                socketID: socket.id,

                isPartyLeader: true,

            }
            game.players.push(player)
            game = await game.save();
            const gameId = game._id.toString();
            socket.join(gameId);
            io.to(gameId).emit('updateGame', game);
        } catch (e) {
            console.log(e)
        }
    });
    ///join 
    socket.on('join-game', async ({ nickname, gameId }) => {
        try {
            if (!gameId.match(/^[0-9a-fA-F]{24}$/)) {
                socket.emit("notCorrectGame", 'Please Enter a valid game Id');
                return;
            }
            let game = await gamemodel.findById(gameId);
            if (game.isJoin) {
                const id = game._id.toString();
                let player = {
                    nickname,
                    socketID: socket.id,
                }
                socket.join(id);
                game.players.push(player);
                game = await game.save();
                io.to(gameId).emit('updateGame', game);

            }
            else {
                socket.emit('notCorrectGame', 'The game is in progress please try again')
            }
        } catch (error) {
            console.log(error)
        }
    });
    socket.on('userInput', async ({ userInput, gameId }) => {
        let game = await gamemodel.findById(gameId);
        if (!game.isJoin && !game.isOver) {
            let player = game.players.find((playerr) => playerr.socketID === socket.id);
            if (game.words[player.currentWordIndex] === userInput.trim()) {
                player.currentWordIndex = player.currentWordIndex + 1;
                if (player.currentWordIndex !== game.words.length) {
                    game = await game.save();
                    io.to(gameId).emit('updateGame', game);
                } else {
                    let endTime = new Date().getTime();
                    let { startTime } = game;
                    player.WPM = calculateWPM(endTime, startTime, player);
                    game = await game.save();
                    socket.emit('done');
                    io.to(gameId).emit('updateGame', game);
                }
            }
        }
    });
    //timer listiner
    socket.on("timer", async ({ playerId, gameId }) => {
        let countdown = 5;
        let game = await gamemodel.findById(gameId);
        let player = game.players.id(playerId);

        if (player.isPartyLeader) {
            let timerId = setInterval(async () => {
                if (countdown >= 0) {
                    io.to(gameId).emit("timer", {
                        countdown,
                        msg: "Game Starting",
                    });
                    console.log(countdown);
                    countdown--;
                } else {
                    game.isJoin = false;
                    game = await game.save();
                    io.to(gameId).emit("updateGame", game);
                    startGameClock(gameId);
                    clearInterval(timerId);
                }
            }, 1000);
        }
    });




});
const startGameClock = async (gameId) => {
    let game = await gamemodel.findById(gameId);
    game.startTime = new Date().getTime();
    game = await game.save();
    let time = 120;
    let timerId = setInterval((async function gameIntervalFunc() {
        if (time >= 0) {
            const timeFormat = calculateTime(time);
            io.to(gameId).emit('timer', {
                countdown: timeFormat
                , msg: "Time is running"

            });
            console.log(time)
            time--;
        } else {
            let endTime = new Date().getTime();
            let game = await gamemodel.findById(gameId);
            let { startTime } = game;
            game.isOver == true;
            game.players.forEach((player, index) => {
                if (player.WPM === -1) {
                    game.players[index].WPM = player.WPM = calculateWPM(endTime, startTime, player);
                }
            });
            game = await game.save();
            io.to(gameId).emit('updateGame', game);
            clearInterval(timerId);
        
        }

    }

    ), 1000);
}

const calculateTime = (time) => {
    let min = Math.floor(time / 60);
    let sec = time % 60;
    return `${min}:${sec < 10 ? "0" + sec : sec}`;
}
const calculateWPM = (endTime, startTime, player) => {
    const timeTakenInSec = (endTime - startTime) / 1000;
    const timeTaken = timeTakenInSec / 60;
    let wordsTyped = player.currentWordIndex;
    const WPM = Math.floor(wordsTyped / timeTaken);
    return WPM;

}
db = mongoose.connect(URL).then(() => {
    console.log("connected");
}).catch((e) => {
    console.log(e)
});

server.listen(port, "0.0.0.0", () => console.log(`Server is running on port ${port}`,),)
