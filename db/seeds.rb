Jack.destroy_all
jack = Jack.create(email: "jack@trades.com",
                   password: "letmein")
johannes = Jack.create(email: "johannes.factotum@trades.com",
                       password: "letmein")

Trade.destroy_all
tailor = Trade.create(name: "Tailor")
reaper = Trade.create(name: "Reaper")
pipe_player = Trade.create(name: "Pipe player")

jack.trades = [tailor, reaper]
