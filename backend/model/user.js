const mongoose = require("mongoose");
const { wishListItemSchema } = require("./wishlist_item");
const { hotelSchema } = require("./adddata");
mongoose.connect(process.env.MONGO_URL).then(function () {
    console.log("mongoose connection established");
}).catch(function (err) {
    console.log(err);
});
const userSchema = mongoose.Schema({
    username: {
        type: String,
        required: true
    },
    email: {
        type: String,
        unique: true,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    address: {
        type: String,
        
    },
    wishList:[
       {hotel: hotelSchema,
        isFav:{type:Boolean}
    }
    ]


});
const User = new mongoose.model("user", userSchema);
module.exports = User;