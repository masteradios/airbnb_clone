const bcrypt = require('bcrypt');
const HttpError = require('../httpError');
const User = require('../model/user');
const e = require('express');
const Trip=require('../model/order');
const jwt=require('jsonwebtoken');
const { hotelSchema } = require('../model/adddata');
async function signUpUser(req, res, next) {
    const {
        username,
        email,
        password
    } = req.body;

    let user = await User.findOne({
        email:email
    });
    if (user) {
        let error = new HttpError("User already exists!!");
        return next(error);
    }
    let newuser;
    let bcryptSalt = bcrypt.genSaltSync(8);
    try {
        newuser = new User({
            username: username,
            email: email,
            password: bcrypt.hashSync(password, bcryptSalt)

        });
        await newuser.save();
        res.json({
            "message": "Account created successfully",
            "user":newuser
        });

    } catch (err) {
        let error = new HttpError(err);
        return next(error);
    }


};

async function loginUser(req,res,next)
{
    
    const {email,password}=req.body;
    try
    {
        console.log("logging");
        let existinguser=await User.findOne({email:email});
        if(existinguser)
        {   
        const isMatch = await bcrypt.compare(password, existinguser.password);
        if (!isMatch) {
            const error = new HttpError("User credentials invalid!!", 401);
            return next(error);
        }
        const token = jwt.sign({
                id: existinguser._id,
            },
            "passwordKey"
        );
        res.status(200).json(
           { token,
            ...existinguser._doc,
            "message":"Login successfull"}
        );
    }  
           
            
        
        else
            {
                console.log("error");
                const error = new HttpError("User credentials invalid!!", 401);
                return next(error);
            }
    }catch(e)
    {
        console.log(e);
        let error=new HttpError("Login failed",400);
        return next(error);
    }




}
async function tokenValid(req, res, next) {
    try {
        const token = req.header("auth-token");
        if (!token) {
            return res.json(false);
        }
        const isVerified = jwt.verify(token, "passwordKey");
        if (!isVerified) {
            return res.json(false);
        }
        let user;
        user = await User.findById(isVerified.id);
        if (!user) {
            return res.json(false);
        }
        res.json(true);
    } catch (err) {
        const error = new HttpError(err.message, 500);
        return next(error);
    }
}

async function auth(req, res, next) {
    try {
        const token = req.header("auth-token");
        if (!token) {
            return new HttpError("No token found. Authentication denied", 401);
        }
        const isVerified = jwt.verify(token, "passwordKey");
        if (!isVerified) {
            return res.status(401).json({
                message: "Token verification failed.Authorization denied!!",
            });
        }
        req.userid = isVerified.id;
        req.token = token;
        next();
    } catch (err) {
        const error = new HttpError(err.message, 500);
        return next(error);
    }
}

async function bookAtrip(req,res,next)
{

const {totalAmount ,
hotel,
numberOfDays,
startDate,endDate,
userid,
numberOfGuests}=req.body;
console.log("got");
let trip=new Trip({
    hotel:hotel,
    startDate:startDate,
    endDate:endDate,
    totalAmount:totalAmount,
    numberOfDays:numberOfDays,
    userid:userid,
    numberOfGuests:numberOfGuests

});
try{await trip.save();
    res.status(200).json({"message":"Reservations confirmed Successfully"});

}catch(err)
{
    const error=new HttpError(err.message,500);
    return next(error);
}


}


async function getUserTrips(req,res,next)
{
    const {userid}=req.body;
    
    try{
        let trips=await Trip.find({userid:userid});
    
        res.status(200).json({"bookedTrips":trips});

    }catch(err)
    {
        const error=new HttpError(err,message,500);
        return next(error);
    }
    
    

}

async function addToWishList(req,res,next){
const {hotel,userid}=req.body;
try{
    let user=await User.findById(userid);
    console.log("got");
    //let token = req.token;
    if(user)
    {
        user.wishList.push({

            hotel:hotel,
            isFav:false
        });

    }
    await user.save();
    console.log("sent");

    res.status(200).json({...user._doc});
    



}catch(err)
{
    const error=new HttpError(err.message,500);
    return next(error);
}
}


exports.signUpUser = signUpUser;
exports.loginUser=loginUser;
exports.tokenValid=tokenValid;
exports.auth=auth;
exports.bookAtrip=bookAtrip;
exports.getUserTrips=getUserTrips;
exports.addToWishList=addToWishList;