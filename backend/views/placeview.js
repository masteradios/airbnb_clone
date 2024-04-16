const {Hotel}=require('../model/adddata');
const express=require('express');
const placeView=express.Router();

placeView.get("/allplaces",async function (req,res,next)
{
    let places=await Hotel.find().limit(10);
    console.log("incoming");
    res.status(200).json({"places":places});
    console.log("sent");
    
});


module.exports=placeView;