'use strict'

const { Client } = require('pg')

// Require the framework and instantiate it
const fastify = require('fastify')({
    logger: true,
})

fastify.register(require('fastify-cors'), {
    // put your options here
})

// Declare a route
fastify.get('/', function (request, reply) {
    reply.send({ hello: 'world' })
})

// Declare a route
fastify.get('/items', function (request, reply) {
    getItems()
    reply.send([
        { name: 'bob', type: 'cat' },
        { name: 'alice', type: 'dog' },
    ])
})

const getItems = async () => {
    const client = new Client()
    await client.connect()
    const res = await client.query('SELECT * FROM cat;')
    console.log(res)
    await client.end()
}

// Run the server!
fastify.listen(process.env.PORT, process.env.HOST, function (err, address) {
    if (err) {
        fastify.log.error(err)
        process.exit(1)
    }
    fastify.log.info(`server listening on ${address}`)
})
