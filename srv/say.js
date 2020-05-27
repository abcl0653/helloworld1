module.exports = say => {
    say.on('hello', req => req.data.to * 2)
    // Change ABC
}