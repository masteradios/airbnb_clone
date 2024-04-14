const fs = require('fs');
const csv = require('csv-parser');
const mongoose = require('mongoose');
require('dotenv').config();
const csvFilePath = 'Hotels.csv'; // Path to your CSV file
const imageUrls = [
    'https://www.abhibus.com/blog/wp-content/uploads/2023/08/Amber-Fort.jpg',
    'https://afar.brightspotcdn.com/dims4/default/62e4d46/2147483647/strip/true/crop/2050x1364+0+0/resize/1440x958!/quality/90/?url=https%3A%2F%2Fafar-media-production-web.s3.us-west-2.amazonaws.com%2Fbrightspot%2F13%2Fc3%2F8e6a4215fd2216f86b1ac3f213ea%2Foriginal-great-wall-hung-chung-chih-shutterstock.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJntfVSWoEsUTGSOn-WXxizRMXlJrEXKZfJg&s',
    'https://www.godigit.com/content/dam/godigit/directportal/en/contenthm/tourist-places-in-pune.jpg',
    'https://delhitourism.gov.in/dttdc/img/new/lotustemple.jpg'
]; // Array of image URLs

// Define the schema for the hotel data
const hotelSchema = new mongoose.Schema({
    hotelName: String,
    price: Number,
    number_of_reviews: Number,
    lat: Number,
    long: Number,
    image_url: String // New field for image URL
});

// Define the model for the hotel data
const Hotel = mongoose.model('Hotel', hotelSchema);

// Function to connect to MongoDB and insert data
async function insertData(data) {
    try {
        await mongoose.connect(process.env.MONGO_URL);
        await Hotel.insertMany(data);
        console.log('Data inserted successfully');
    } catch (error) {
        console.error('Error inserting data:', error);
    } finally {
        await mongoose.disconnect();
    }
}

// Read CSV file, assign random image URLs, and insert data into MongoDB
const hotelsData = [];
fs.createReadStream(csvFilePath)
    .pipe(csv())
    .on('data', (row) => {
        // Manipulate row if needed
        // Map CSV column names to Mongoose model fields
        const hotelData = {
            hotelName: row.HOTEL,
            price: parseFloat(row.PRICE_RUPEES),
            number_of_reviews: parseInt(row.NUMBER_OF_REVIEWS),
            lat: parseFloat(row.Lat),
            long: parseFloat(row.Lng),
            image_url: imageUrls[Math.floor(Math.random() * imageUrls.length)] // Assign random image URL
        };
        hotelsData.push(hotelData);
    })
    .on('end', () => {
        insertData(hotelsData);
    });
