const { default: mongoose } = require("mongoose");
const {hotelSchema}=require('../model/adddata');
const wishListItemSchema=mongoose.Schema({

    place:hotelSchema,



});
exports.wishListItemSchema=wishListItemSchema;