require('dotenv').config();
const express = require("express");
const app = express();
const port = 3000;
const HttpError = require('./httpError');
const userView=require('./views/userview');
var cors = require('cors');


app.use(express.json());
app.use("/users",userView);


//showing error if request is sent to route that doesnt exist

app.use(function (req, res, next) {
    return next(new HttpError("Page not found", 404));
  });
  
  //Showing error if there are any,in all routes
  app.use(function (error, req, res, next) {
    if (res.headerSent) {
      return next(error);
    }
    res.status(error.code || 500).json({
      message: error.message || "Unknown error occured",
    });
  });







app.listen(port, () => {
    console.log(`Listening on ${port}`);
});