const express=require('express');
const userView=express.Router();
const userController=require('../controllers/userController');
userView.post("/signup", userController.signUpUser);

userView.get("/signup", (req,res)=>
{
    console.log("sign");
    res.json({body:"something"});
});

userView.post("/login",userController.loginUser);


module.exports=userView;