//get the var env from file keys
const keys = require('./keys');

//import redis client
const redis = require ('redis');

//create the redis cliente
const redisClient = redis.createClient ({
    //ghet the kvar from the keys
    host: keys.redisHost,
    port: keys.redisPort,
    retry_strategy: () => 1000 //tell the redis cliente if lose the connection, to reconnect after 1000 miliseconds
});

//make a duplicate for the redis cliente
const sub = redisClient.duplicate();

//create the function to calculate the fibo
function fib (index) {
    if (index < 2) return 1;
    return fib(index -1) + fib(index -2); //this function is very slow (recursively), for testing puposes only
}

//watch Redis for new message and run the callback function FIB
sub.on('message', (channel, message) => {
    //insert it on a hash of values, and push the value to redis
    redisClient.hset('values', message, fib(parseInt(message)));
});
//after the new message is calculated insert it on redis.
sub.subscribe('insert');