const express=require('express');
const userView=express.Router();
const User=require('../model/user');
const userController=require('../controllers/userController');
userView.post("/signup", userController.signUpUser);

userView.get("/signup", (req,res)=>
{
    console.log("sign");
    res.json({body:"something"});
});

userView.post("/login",userController.loginUser);
userView.post("/tokenValid",userController.tokenValid);
userView.get("/",userController.auth,async (req,res,next)=>
{
    let user;
    user=await User.findById(req.userid);
    res.json({...user._doc,token:req.token});
})
userView.post("/booktrip",userController.bookAtrip);

module.exports=userView;