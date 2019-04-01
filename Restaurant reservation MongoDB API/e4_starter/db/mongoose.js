'use strict';

const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/RestaurantAPI', { useNewUrlParser: true, useCreateIndex: true});

mongoose.connection.once('open',function(){
	console.log('connected')
}).on('error',function(error){
	console.log('error')
})

module.exports = {
	mongoose
}