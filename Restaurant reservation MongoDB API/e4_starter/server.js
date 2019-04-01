/* E4 server.js */
"use strict";
const log = console.log;

const express = require("express");
const bodyParser = require("body-parser");
const { ObjectID } = require("mongodb");

// Mongoose
const { mongoose } = require("./db/mongoose");
const { Restaurant } = require("./models/restaurant");

// Express
const port = process.env.PORT || 3000;
const app = express();
app.use(bodyParser.json());

/// Route for adding restaurant, with *no* reservations (an empty array).
/* 
Request body expects:
{
	"name": <restaurant name>
	"description": <restaurant description>
}
Returned JSON should be the database document added.
*/
// POST /restaurants
//receive (req,res) promise structure from client with restaurant name
app.post("/restaurants", (req, res) => {
	// Add code here
  	//create new restaurant instance, which is exported in restaurant.js
  	const restaurant = new Restaurant({
  		//data fields
    	name: req.body.name,
    	description: req.body.description,
    	reservations: []
  	});
  	// promise.save().then(): wait until asynchronous data from client is received
  	restaurant.save().then((result) => {
    	// push to database server
      	//result 
      	res.send( result )
    },(error) => {
      	// 400 means bad request
      	res.status(400).send(error); 
    }
  );
});

/// Route for getting all restaurant information.
// GET /restaurants
app.get("/restaurants", (req, res) => {
  	// Add code here
  	//use model.find()with no argument to find all info
  	//Restaurant module by restaurant.js
  	Restaurant.find().then((restaurant) => {
     	res.send({ restaurant });
    },(error) => {
    	// 400 means bad request
      	res.status(400).send(error);
    }
  	);
});

/// Route for getting information for one restaurant.
// GET /restaurants/id in postMan
app.get("/restaurants/:id", (req, res) => {
  // Add code here
  //get id info from promise req jason
  const id = req.params.id;
  //check if id is not valid
  if (!ObjectID.isValid(id)) {
		res.status(404).send();
  }


  	//otherwise find by id
    Restaurant.findById(id).then((restaurant) => {
    	//if restaurant not found
      	if (!restaurant) {
        	res.status(404).send();
      	} else {
        	res.send( restaurant );
      	}
    	}).catch((error) => {
    		res.status(500).send()
    	}) 
  });

/// Route for adding reservation to a particular restaurant.
/* 
Request body expects:
{
	"time": <time>
	"people": <number of people>
}
*/
// Returned JSON should have the restaurant database
//   document that the reservation was added to, AND the reservation subdocument:
//   { "reservation": <reservation subdocument>, "restaurant": <entire restaurant document>}
// POST /restaurants/id
app.post("/restaurants/:id", (req, res) => {

  //initialize command
  // Make Mongoose use `findOneAndUpdate()`. Note that this option is `true`
  // by default, you need to set it to false.
  mongoose.set("useFindAndModify", false);
  // Add code here
  //pass in id from post where for example /restaurants/abc <- abc is the id
  const id = req.params.id;
  //extract reservation json
  const reservation = {
    time: req.body.time,
    people: req.body.people
  };

  //check if id is not valid
  if (!ObjectID.isValid(id)) {
    res.status(404).send();
  }


  //otherwise find by id
  Restaurant.findById(id).then((restaurant) => {
  	//if restaurant not found
  	if (!restaurant) {
       res.status(404).send();
    } 
    //find the return jason file
    else {
      //restaurant is the schema returned previously
      //get all existing reservations
      const allreservations = restaurant.reservations;
      //push new reservation in
      allreservations.push(reservation);
      //update the new restaurant status
      //Model.findByIdAndUpdate(id, { name: 'jason bourne' }, options, callback)
      //example: Model.findByIdAndUpdate(id, { $set: { name: 'jason bourne' }}, options, callback)

      //In Mongoose 4.0, the default value for the new option of findByIdAndUpdate (and findOneAndUpdate) has changed to false (see #2262 of the release notes). This means that you need to explicitly set the option to true to get the new version of the doc, after the update is applied:
      //Model.findByIdAndUpdate(id, updateObj, {new: true}, function(err, model) {...
      Restaurant.findByIdAndUpdate(
        id,{
          $set: {
            reservations: allreservations
          }
      	},
      	//ensure the new document can be extracted in the future
        { new: true }
        // .then() waits for the process to end
      ).then((restaurant) => {
      	  //send jason to client
      	  //structure:{ "reservation": <reservation subdocument>, "restaurant": <entire restaurant document>}
          res.send({reservation, restaurant});
        })
        // if .then() error
        .catch((error) => {
          res.status(400).send(error);
        });
    }
  });
});


/// Route for getting information for one reservation of a restaurant (subdocument)
// GET /restaurants/id
//example : GET http://localhost:3000/restaurants/abc/def
app.get("/restaurants/:id/:resv_id", (req, res) => {
  // Add code here
  //extract restaurant and reservation id
  const restId = req.params.id;
  const resvId = req.params.resv_id;
  //check is both id valid
  if (!ObjectID.isValid(restId)) {
    res.status(404).send();
  } 
  if (!ObjectID.isValid(resvId)) {
    res.status(404).send();
  } 

  //if ids are valid
  Restaurant.findById(restId).then((restaurant) => {
  		//if restaurant not found
        if (!restaurant) {
          res.status(404).send();
        } 
        else {
          //if resteraurant has this reservation
          if (restaurant.reservations.id(resvId) !== null) {
          	//extract reservation jason block
            const reservation = restaurant.reservations.id(resvId);
            //send to client
            res.send(reservation);
          } 
          //if resteraurant does not has this reservation
          else {
          	//if not exist
            res.status(404).send();
          }
        }
    })
    //if .findById.then() error
    .catch(error => {
        res.status(400).send(error);
    });
  
});

/// Route for deleting reservation
// Returned JSON should have the restaurant database
//   document from which the reservation was deleted, AND the reservation subdocument deleted:
//   { "reservation": <reservation subdocument>, "restaurant": <entire restaurant document>}
// DELETE restaurant/<restaurant_id>/<reservation_id>
app.delete("/restaurants/:id/:resv_id", (req, res) => {
  //initialize command
  // Make Mongoose use `findOneAndUpdate()`. Note that this option is `true`
  // by default, you need to set it to false.
  mongoose.set("useFindAndModify", false);
  // Add code here
  const restId = req.params.id;
  const resvId = req.params.resv_id;
  //check is both id valid
  if (!ObjectID.isValid(restId)) {
    res.status(404).send();
  } 
  if (!ObjectID.isValid(resvId)) {
    res.status(404).send();
  } 
  	//if ids are valid
    Restaurant.findById(restId).then(restaurant => {
    	//if restaurant not found
        if (!restaurant) {
          res.status(404).send();
        } 
        //if restaurant exists
        else {
          //if resteraurant has this reservation
          if (restaurant.reservations.id(resvId) !== null) {
          	//get reservation jason block that needs to be deleted
            const reservation = restaurant.reservations.id(resvId);
            //get all existing reservations jason file of this restaurant
            const allreservation = restaurant.reservations;
            //delete reservation from all reservations
            //assume no duplicated reservations (no same restID)
            //filter out deleted reservation, store result in "ans"
            const ans = allreservation.filter((item) => {
              if (item !== reservation){
              	return item;
              }
            });
            //update the new restaurant status
      		//Model.findByIdAndUpdate(id, { name: 'jason bourne' }, options, callback)
      		//example: Model.findByIdAndUpdate(id, { $set: { name: 'jason bourne' }}, options, callback)
      		//In Mongoose 4.0, the default value for the new option of findByIdAndUpdate (and findOneAndUpdate) has changed to false (see #2262 of the release notes). This means that you need to explicitly set the option to true to get the new version of the doc, after the update is applied:
      		//Model.findByIdAndUpdate(id, updateObj, {new: true}, function(err, model) {...
            Restaurant.findByIdAndUpdate(
              restId, {
                $set: {
                  reservations: ans
                }
              },
              //ensure the new document can be extracted in the future
              { new: true }
              // .then() waits for the process to end
            ).then((restaurant) => {
            	//client jason format: //   { "reservation": <reservation subdocument>, "restaurant": <entire restaurant document>} 
                res.send({reservation, restaurant});
              })
              //if .then() encountered error 
              .catch((error) => {
                res.status(400).send(error);
              });
          } 
          //if resteraurant does not has this reservation
          else {
            res.status(404).send();
          }
        }
      })
      //findByIdAndUpdate().then() error
      .catch(error => {
        res.status(400).send(error);
      });
  
});

/// Route for changing reservation information
/* 
Request body expects:
{
	"time": <time>
	"people": <number of people>
}
*/
// Returned JSON should have the restaurant database
//   document in which the reservation was changed, AND the reservation subdocument changed:
//   { "reservation": <reservation subdocument>, "restaurant": <entire restaurant document>}
// PATCH restaurant/<restaurant_id>/<reservation_id>
//patch changes the reservation info with certain restaurant_id & reservation_id
app.patch("/restaurants/:id/:resv_id", (req, res) => {
  //initialize command
  // Make Mongoose use `findOneAndUpdate()`. Note that this option is `true`
  // by default, you need to set it to false.
  mongoose.set("useFindAndModify", false);
  //get new(update) reservation info
  const newReservation = {
    time: req.body.time,
    people: req.body.people
  }
  //from "/restaurants/:id/:resv_id" extract id and resv_id
  const restId = req.params.id;
  const resvId = req.params.resv_id;
  //check is both id valid
  if (!ObjectID.isValid(restId)) {
    res.status(404).send();
  } 
  if (!ObjectID.isValid(resvId)) {
    res.status(404).send();
  } 
  	//if ids are valid
    Restaurant.findById(restId).then(restaurant => {
    	//if restaurant not found
        if (!restaurant) {
          res.status(404).send();
        } 
		//if restaurant exists
        else {
          //if resteraurant has this reservation
          if (restaurant.reservations.id(resvId) !== null) {
          	//get reservation jason block that needs to be deleted
            const reservation = restaurant.reservations.id(resvId);
            //get all existing reservations jason file of this restaurant
            const allreservation = restaurant.reservations;
            //use filter to modify info and store in ans
            const ans = allreservation.filter((item) => {
            	//if current reservation is to be modified
                if (item === reservation) {
                  //note : item = newReservation; will not work because item has more attributes than newReservation
                  //modify with given req info
                  item.time = req.body.time;
                  item.people = req.body.people;
                  
                }
                //if not to be modified, return directly
                return item;
              }
            )
            //update the new restaurant status
      		//Model.findByIdAndUpdate(id, { name: 'jason bourne' }, options, callback)
      		//example: Model.findByIdAndUpdate(id, { $set: { name: 'jason bourne' }}, options, callback)
      		//In Mongoose 4.0, the default value for the new option of findByIdAndUpdate (and findOneAndUpdate) has changed to false (see #2262 of the release notes). This means that you need to explicitly set the option to true to get the new version of the doc, after the update is applied:
      		//Model.findByIdAndUpdate(id, updateObj, {new: true}, function(err, model) {...
            Restaurant.findByIdAndUpdate(
              restId, {
              	//modify reservation data
                $set: {
                  reservations: ans
                }
              },
              //ensure the new document can be extracted in the future
              {new: true}
            ).then((restaurant) => {
            	//client format: { "reservation": <reservation subdocument>, "restaurant": <entire restaurant document>}
                res.send({newReservation, restaurant});
              })
              // update.then()error
              .catch((error) => {
                res.status(400).send(error);
              });
          } 
          //if resteraurant does not have this reservation
          else {
            res.status(404).send();
          }
        }
      })
       //.then() error
      .catch(error => {
        res.status(400).send(error);
      });
  
});


app.listen(port, () => {
  log(`Listening on port ${port}...`);
});