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
fastify.get('/cats', async function (request, reply) {
    let cats = await getCats()
    reply.send(cats)
})

fastify.post('/cat', async function (request, reply) {
    await createCat(request.body)
    return { cat: 'created' }
})

fastify.delete('/cat', async function (request, reply) {
    await deleteCat(request.body)
    return { cat: 'deleted' }
})

const getCats = async () => {
    const client = new Client()
    await client.connect()
    const res = await client.query('SELECT * FROM cat;')
    await client.end()
    return res.rows
}

const createCat = async ({ name, color }) => {
    const client = new Client()
    await client.connect()
    await client.query(
        `INSERT INTO cat (name, color) VALUES ('${name}', '${color}');`
    )
    await client.end()
}

const deleteCat = async ({ cat_id }) => {
    const client = new Client()
    await client.connect()
    const res = await client.query(`DELETE FROM CAT WHERE cat_id='${cat_id}';`)
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
