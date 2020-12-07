'use strict'

const { Client } = require('pg')

// Require the framework and instantiate it
const fastify = require('fastify')({
    logger: true,
})
const path = require('path')

fastify.register(require('fastify-static'), {
    root: path.join(__dirname, 'build'),
})

fastify.get('/', function (req, reply) {
    return reply.sendFile('index.html')
})

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

    const text = 'INSERT INTO cat(name, color) VALUES($1, $2)'
    const values = [name, color]
    await client.query(text, values)

    await client.end()
}

const deleteCat = async ({ cat_id }) => {
    const client = new Client()
    await client.connect()

    const text = 'DELETE FROM CAT WHERE cat_id=$1;'
    const values = [cat_id]
    await client.query(text, values)

    await client.end()
}

// Run the server!
fastify.listen(process.env.PORT, '0.0.0.0', function (err, address) {
    if (err) {
        fastify.log.error(err)
        process.exit(1)
    }
    fastify.log.info(`server listening on ${address}`)
})
