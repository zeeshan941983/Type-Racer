const axios=require("axios");
const getSentence=async()=>{
 const data=await  axios.get('http://api.quotable.io/random');
return data.data.content.split(' ');
}

module.exports=getSentence;