import { Component } from 'react'

import 'bootstrap/dist/css/bootstrap.min.css'

import Table from 'react-bootstrap/Table'
import Form from 'react-bootstrap/Form'
import Button from 'react-bootstrap/Button'

import './App.css'

const backendUrl = 'http://apitest.playground.zisops.com:4000/'

class App extends Component {
    constructor(props) {
        super(props)
        this.state = {
            error: null,
            isLoaded: false,
            items: [],
        }

        this.handleSubmit = this.handleSubmit.bind(this)
        this.deleteCat = this.deleteCat.bind(this)
    }

    componentDidMount() {
        fetch(backendUrl + 'cats')
            .then((res) => res.json())
            .then(
                (result) => {
                    this.setState({
                        isLoaded: true,
                        items: result,
                    })
                },
                // Note: it's important to handle errors here
                // instead of import { React } from 'react';
                // a catch() block so that we don't swallow
                // exceptions from actual bugs in components.
                (error) => {
                    this.setState({
                        isLoaded: true,
                        error,
                    })
                }
            )
    }

    async handleSubmit(event) {
        event.preventDefault()
        console.log(event)

        const name = event.target[0].value
        const color = event.target[1].value

        console.log(name, color)

        // Simple POST request with a JSON body using fetch
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name: name, color: color }),
        }
        await fetch(backendUrl + 'cat', requestOptions)

        fetch(backendUrl + 'cats')
            .then((res) => res.json())
            .then(
                (result) => {
                    this.setState({
                        items: result,
                    })
                },
                (error) => {
                    this.setState({
                        error,
                    })
                }
            )
    }

    async deleteCat(cat_id, event) {
        event.preventDefault()
        console.log(cat_id)

        const requestOptions = {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ cat_id: cat_id }),
        }
        await fetch(backendUrl + 'cat', requestOptions)

        fetch(backendUrl + 'cats')
            .then((res) => res.json())
            .then(
                (result) => {
                    this.setState({
                        items: result,
                    })
                },
                (error) => {
                    this.setState({
                        error,
                    })
                }
            )
    }

    render() {
        const { error, isLoaded, items } = this.state
        if (error) {
            return <div>Error: {error.message}</div>
        } else if (!isLoaded) {
            return <div>Loading...</div>
        } else {
            return (
                <div className='tableWrapper'>
                    <h1 className='tableCaption'>Katzen</h1>
                    <Form className='catForm' onSubmit={this.handleSubmit}>
                        <Form.Group controlId='formName'>
                            <Form.Label>Name</Form.Label>
                            <Form.Control
                                type='Name'
                                placeholder='Name eingeben'
                            />
                        </Form.Group>

                        <Form.Group controlId='formColor'>
                            <Form.Label>Farbe</Form.Label>
                            <Form.Control
                                type='Farbe'
                                placeholder='Farbe eingeben'
                            />
                        </Form.Group>
                        <Button variant='primary' type='submit'>
                            Erstellen
                        </Button>
                    </Form>
                    <Table striped bordered hover>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Farbe</th>
                                <th>Löschen</th>
                            </tr>
                        </thead>
                        <tbody>
                            {items.map((item) => (
                                <tr key={item.cat_id}>
                                    <td>{item.cat_id}</td>
                                    <td>{item.name}</td>
                                    <td>{item.color}</td>
                                    <td>
                                        <Button
                                            className='tableBtn'
                                            variant='primary'
                                            type='submit'
                                            onClick={(e) =>
                                                this.deleteCat(item.cat_id, e)
                                            }
                                        >
                                            Löschen
                                        </Button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </Table>
                </div>
            )
        }
    }
}

export default App
