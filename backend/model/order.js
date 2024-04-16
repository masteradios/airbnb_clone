const mongoose = require("mongoose");
const {hotelSchema}=require('../model/adddata');
const tripSchema=mongoose.Schema({

    totalAmount :{type:Number,required: true},
    hotel:hotelSchema,
    numberOfDays:{type:Number,required: true},
    userid:{type:String,required: true},
    numberOfGuests:{type:Number,required: true}


});
const Trip=mongoose.model("trip",tripSchema);
module.exports=Trip;