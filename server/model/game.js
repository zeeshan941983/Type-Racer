const mongoose =require('mongoose');
const playerScrema = require('./player');

 const gameschema=new mongoose.Schema({
words:[
    {
        type:String,
    }
],
players:[playerScrema],
isJoin:{
    type:Boolean,
    default : true

},
isOver:{
    type:Boolean,
    default : false

},
startTime:{
    type:Number
}

 });
 const gamemodel=mongoose.model('game',gameschema);
 module.exports=gamemodel;