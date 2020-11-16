import './App.css'
import { Component } from 'react'

class App extends Component {
    constructor(props) {
        super(props)
        this.state = {
            error: null,
            isLoaded: false,
            items: [],
        }
    }

    componentDidMount() {
        fetch('http://localhost:4000/items')
            .then((res) => res.json())
            .then(
                (result) => {
                    console.log(result)
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

    render() {
        const { error, isLoaded, items } = this.state
        if (error) {
            return <div>Error: {error.message}</div>
        } else if (!isLoaded) {
            return <div>Loading...</div>
        } else {
            return (
                <ul>
                    {items.map((item) => (
                        <li key={item.id}>
                            {item.name} {item.type}
                        </li>
                    ))}
                </ul>
            )
        }
    }
}

export default App
